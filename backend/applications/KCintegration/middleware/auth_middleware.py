from django.conf import settings
from django.http import JsonResponse
import jwt
from jwt.exceptions import InvalidTokenError, ExpiredSignatureError
import requests
import logging
import time
import base64

logger = logging.getLogger(__name__)

class KeycloakMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response
        self.jwks_cache = None
        self.jwks_cache_time = None

    def _get_jwks(self):
        """
        Obtiene las claves JWKS de Keycloak con cache simple
        """
        # Cache por 1 hora
        if (self.jwks_cache and self.jwks_cache_time and 
            time.time() - self.jwks_cache_time < 3600):
            return self.jwks_cache
        
        try:
            jwks_url = f"{settings.KEYCLOAK_URL}/realms/{settings.KEYCLOAK_REALM}/protocol/openid-connect/certs"
            response = requests.get(jwks_url, verify=False, timeout=5)
            response.raise_for_status()
            
            self.jwks_cache = response.json()
            self.jwks_cache_time = time.time()
            logger.debug(f"JWKS fetched successfully: {len(self.jwks_cache.get('keys', []))} keys")
            return self.jwks_cache
        except Exception as e:
            logger.error(f"Error fetching JWKS: {e}")
            raise

    def _get_token_from_header(self, request):
        """Extrae el token del header Authorization"""
        auth_header = request.headers.get('Authorization', '')
        if not auth_header.startswith('Bearer '):
            return None
        return auth_header.split(' ')[1]

    def _validate_jwks_available(self, jwks):
        """
        Verifica que las claves JWKS estén disponibles
        """
        if not jwks or 'keys' not in jwks:
            raise InvalidTokenError("JWKS not available")
        
        if not jwks['keys']:
            raise InvalidTokenError("No keys available in JWKS")
        
        return True

    def _find_signing_key(self, jwks, kid):
        """
        Encuentra la clave de firma correspondiente al kid del token
        """
        for key in jwks.get('keys', []):
            if key.get('kid') == kid and key.get('kty') == 'RSA':
                return key
        return None

    def _validate_token(self, token):
        """
        Valida el token JWT con verificación básica (sin firma por ahora)
        """
        try:
            # Obtener el header del token para extraer el kid
            header = jwt.get_unverified_header(token)
            kid = header.get('kid')
            
            if not kid:
                raise InvalidTokenError("Token missing 'kid' in header")
            
            # Obtener las claves JWKS para verificar que estén disponibles
            jwks = self._get_jwks()
            self._validate_jwks_available(jwks)
            
            # Buscar la clave correspondiente
            signing_key_jwk = self._find_signing_key(jwks, kid)
            if not signing_key_jwk:
                raise InvalidTokenError(f"Key with kid '{kid}' not found in JWKS")
            
            # Por ahora, validar sin verificar la firma (temporal)
            # TODO: Implementar validación de firma completa
            decoded_token = jwt.decode(
                token,
                options={
                    "verify_signature": False,  # Temporal: sin verificación de firma
                    "verify_exp": True,
                    "verify_aud": True,
                    "verify_iss": True
                },
                audience=settings.KEYCLOAK_CLIENT_ID,
                issuer=f"{settings.KEYCLOAK_URL}/realms/{settings.KEYCLOAK_REALM}"
            )
            
            # Validaciones adicionales de seguridad
            self._validate_token_claims(decoded_token)
            
            logger.debug(f"Token validated successfully for user: {decoded_token.get('preferred_username', 'unknown')}")
            return decoded_token

        except ExpiredSignatureError:
            logger.error("Token has expired")
            raise
        except InvalidTokenError as e:
            logger.error(f"Invalid token: {str(e)}")
            raise
        except Exception as e:
            logger.error(f"Error validating token: {str(e)}")
            raise

    def _validate_token_claims(self, decoded_token):
        """
        Valida claims adicionales del token para mayor seguridad
        """
        # Validar que el token no esté expirado (ya verificado por jwt.decode)
        current_time = time.time()
        if decoded_token.get('exp', 0) <= current_time:
            raise InvalidTokenError("Token has expired")
        
        # Validar que el token sea reciente (no más de 24 horas)
        if decoded_token.get('iat', 0) < current_time - 86400:
            logger.warning("Token is older than 24 hours")
        
        # Validar que el token tenga los claims necesarios
        required_claims = ['sub', 'iss', 'aud', 'exp', 'iat']
        for claim in required_claims:
            if claim not in decoded_token:
                raise InvalidTokenError(f"Token missing required claim: {claim}")
        
        # Validar que el token tenga al menos un rol
        realm_access = decoded_token.get('realm_access', {})
        roles = realm_access.get('roles', [])
        if not roles:
            logger.warning("Token has no roles assigned")
        
        logger.debug(f"Token claims validated successfully. Roles: {roles}")

    def __call__(self, request):
        # Lista de rutas públicas que no requieren autenticación
        public_paths = ['/api/public/', '/admin/']
        
        # Si es una ruta pública, permitimos el acceso sin validación
        if any(request.path.startswith(path) for path in public_paths):
            return self.get_response(request)

        # Para rutas protegidas, validamos el token
        token = self._get_token_from_header(request)
        if not token:
            return JsonResponse(
                {'error': 'Authentication credentials were not provided'}, 
                status=401
            )

        try:
            decoded_token = self._validate_token(token)

            # Agregar información del usuario al request
            request.user_info = {
                'sub': decoded_token.get('sub'),
                'preferred_username': decoded_token.get('preferred_username'),
                'email': decoded_token.get('email'),
                'name': decoded_token.get('name'),
                'given_name': decoded_token.get('given_name'),
                'family_name': decoded_token.get('family_name')
            }
            request.user_roles = decoded_token.get('realm_access', {}).get('roles', [])
            
            return self.get_response(request)

        except (ExpiredSignatureError, InvalidTokenError) as e:
            logger.error(f"Token validation failed: {str(e)}")
            return JsonResponse({'error': 'Invalid token'}, status=401)
        except Exception as e:
            logger.error(f"Authentication error: {str(e)}")
            return JsonResponse({'error': 'Authentication failed'}, status=401) 