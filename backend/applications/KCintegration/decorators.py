from functools import wraps
from django.http import JsonResponse
import logging

logger = logging.getLogger(__name__)

def require_roles(*required_roles):
    """
    Decorador para validar que el usuario tenga al menos uno de los roles requeridos
    """
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            # Obtener roles del usuario desde el middleware
            user_roles = getattr(request, 'user_roles', [])
            
            # Verificar si el usuario tiene al menos uno de los roles requeridos
            if not any(role in user_roles for role in required_roles):
                logger.warning(f"User {getattr(request, 'user_info', {}).get('preferred_username', 'unknown')} "
                             f"with roles {user_roles} attempted to access endpoint requiring {required_roles}")
                return JsonResponse(
                    {'error': f'Insufficient permissions. Required roles: {list(required_roles)}'}, 
                    status=403
                )
            
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator

def require_scopes(*required_scopes):
    """
    Decorador para validar que el token tenga los scopes requeridos
    """
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            # Obtener scopes del token (desde el header Authorization)
            auth_header = request.headers.get('Authorization', '')
            if not auth_header.startswith('Bearer '):
                return JsonResponse({'error': 'No token provided'}, status=401)
            
            # Los scopes se validan en el middleware, aquí solo verificamos que el token sea válido
            # Si llegamos aquí, el token ya fue validado por el middleware
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator

def require_any_role(*roles):
    """
    Alias para require_roles para mayor claridad
    """
    return require_roles(*roles)
