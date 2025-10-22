import Keycloak from 'keycloak-js';
import axios from 'axios';

/**
 * Inicializa y configura el cliente Keycloak según el ambiente actual
 */
export const initKeycloak = async () => {
  try {
    const env = import.meta.env.VITE_ENV || 'LOCAL';
    
    const keycloakConfig = {
      url: import.meta.env[`VITE_KEYCLOAK_URL_${env}`],
      realm: import.meta.env[`VITE_KEYCLOAK_REALM_${env}`],
      clientId: import.meta.env[`VITE_KEYCLOAK_CLIENT_ID_${env}`]
    };

    console.log('Current environment:', env);
    console.log('Keycloak config:', keycloakConfig);

    const keycloakClient = new Keycloak(keycloakConfig);

    await keycloakClient.init({
      onLoad: null,  // No verificar SSO automáticamente
      pkceMethod: 'S256',
      checkLoginIframe: false,
      redirectUri: window.location.origin,
      enableLogging: true,
      checkLoginIframeInterval: 0,  // Deshabilitar verificación de iframe
      responseMode: 'fragment'  // Usar fragment mode para evitar CORS
    });

    // Configurar interceptor de Axios para tokens
    setupAxiosInterceptors(keycloakClient);

    return {
      keycloak: keycloakClient,
      authenticated: keycloakClient.authenticated || false
    };
  } catch (error) {
    console.error('Keycloak init error:', error);
    throw error;
  }
};

/**
 * Configura los interceptores de Axios para incluir el token en las peticiones
 * y manejar tokens expirados automáticamente
 */
const setupAxiosInterceptors = (keycloakClient) => {
  // Interceptor de request: agrega el token a todas las peticiones
  axios.interceptors.request.use(
    (config) => {
      if (keycloakClient.authenticated && keycloakClient.token) {
        config.headers.Authorization = `Bearer ${keycloakClient.token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );

  // Interceptor de response: maneja tokens expirados con rotación automática
  axios.interceptors.response.use(
    (response) => response,
    async (error) => {
      const originalRequest = error.config;
      
      // Si es un error 401 y no hemos intentado refrescar el token
      if (error.response?.status === 401 && !originalRequest._retry) {
        originalRequest._retry = true;
        
        try {
          console.log('Token expirado, intentando refresh...');
          
          // Intentar refrescar el token con timeout
          const refreshed = await keycloakClient.updateToken(30);
          
          if (refreshed) {
            console.log('Token refrescado exitosamente');
            
            // Actualizar el header de autorización con el nuevo token
            originalRequest.headers.Authorization = `Bearer ${keycloakClient.token}`;
            
            // Reintentar la petición original
            return axios(originalRequest);
          } else {
            console.log('No se pudo refrescar el token, redirigiendo al login');
            keycloakClient.login();
            return Promise.reject(new Error('Token refresh failed'));
          }
        } catch (refreshError) {
          console.error('Error refreshing token:', refreshError);
          
          // Si no se puede refrescar, limpiar el estado y redirigir al login
          try {
            await keycloakClient.logout();
          } catch (logoutError) {
            console.error('Error during logout:', logoutError);
          }
          
          // Redirigir al login
          keycloakClient.login();
          return Promise.reject(refreshError);
        }
      }
      
      // Si ya intentamos refrescar y sigue fallando, no reintentar
      if (originalRequest._retry) {
        console.error('Token refresh already attempted, redirecting to login');
        keycloakClient.login();
      }
      
      return Promise.reject(error);
    }
  );
};

/**
 * Inicia sesión en Keycloak
 */
export const login = (keycloak) => {
  if (keycloak) {
    return keycloak.login({
      redirectUri: window.location.origin,
      scope: 'openid profile email'
    });
  }
  return Promise.reject('Keycloak no inicializado');
};

/**
 * Cierra sesión en Keycloak
 */
export const logout = (keycloak) => {
  if (keycloak) {
    return keycloak.logout({
      redirectUri: window.location.origin
    });
  }
  return Promise.reject('Keycloak no inicializado');
};

/**
 * Verifica si el usuario está autenticado y maneja el refresh automático
 */
export const checkAuthStatus = async (keycloak) => {
  if (!keycloak) {
    return { authenticated: false, error: 'Keycloak no inicializado' };
  }

  try {
    // Verificar si el token está próximo a expirar (menos de 30 segundos)
    if (keycloak.authenticated && keycloak.tokenParsed) {
      const now = Math.floor(Date.now() / 1000);
      const tokenExp = keycloak.tokenParsed.exp;
      const timeUntilExpiry = tokenExp - now;

      // Si el token está próximo a expirar, intentar refrescarlo
      if (timeUntilExpiry < 30) {
        console.log(`Token próximo a expirar en ${timeUntilExpiry} segundos, refrescando...`);
        
        try {
          const refreshed = await keycloak.updateToken(30);
          if (refreshed) {
            console.log('Token refrescado exitosamente');
          } else {
            console.log('No se pudo refrescar el token, redirigiendo al login');
            await keycloak.login();
            return { authenticated: false, error: 'Token refresh failed' };
          }
        } catch (refreshError) {
          console.error('Error durante el refresh del token:', refreshError);
          await keycloak.login();
          return { authenticated: false, error: 'Token refresh error' };
        }
      }
    }

    return {
      authenticated: keycloak.authenticated || false,
      userInfo: keycloak.authenticated ? extractUserInfo(keycloak) : null,
      tokenExpiry: keycloak.authenticated && keycloak.tokenParsed ? 
        new Date(keycloak.tokenParsed.exp * 1000).toISOString() : null
    };
  } catch (error) {
    console.error('Error verificando estado de autenticación:', error);
    return { authenticated: false, error: error.message };
  }
};

/**
 * Inicia la rotación automática de tokens en segundo plano
 */
export const startTokenRotation = (keycloak) => {
  if (!keycloak || !keycloak.authenticated) {
    return;
  }

  // Verificar cada 30 segundos si el token necesita ser refrescado
  const rotationInterval = setInterval(async () => {
    if (!keycloak.authenticated) {
      clearInterval(rotationInterval);
      return;
    }

    try {
      const now = Math.floor(Date.now() / 1000);
      const tokenExp = keycloak.tokenParsed?.exp;
      
      if (tokenExp) {
        const timeUntilExpiry = tokenExp - now;
        
        // Si el token expira en menos de 60 segundos, refrescarlo
        if (timeUntilExpiry < 60 && timeUntilExpiry > 0) {
          console.log('Rotación automática: Token próximo a expirar, refrescando...');
          const refreshed = await keycloak.updateToken(30);
          
          if (!refreshed) {
            console.log('Rotación automática: No se pudo refrescar, limpiando intervalo');
            clearInterval(rotationInterval);
          }
        }
      }
    } catch (error) {
      console.error('Error en rotación automática de tokens:', error);
      clearInterval(rotationInterval);
    }
  }, 30000); // Verificar cada 30 segundos

  return rotationInterval;
};

/**
 * Detiene la rotación automática de tokens
 */
export const stopTokenRotation = (intervalId) => {
  if (intervalId) {
    clearInterval(intervalId);
  }
};

/**
 * Extrae información del usuario desde el token
 */
export const extractUserInfo = (keycloak) => {
  if (!keycloak || !keycloak.tokenParsed) {
    return null;
  }
  
  const tokenData = keycloak.tokenParsed;
  
  return {
    name: tokenData.name || 'No disponible',
    email: tokenData.email || 'No disponible',
    rut: tokenData.rut_numero && tokenData.rut_dv 
      ? `${tokenData.rut_numero}-${tokenData.rut_dv}` 
      : 'No disponible',
    email_verified: tokenData.email_verified || false,
    preferred_username: tokenData.preferred_username || 'No disponible',
    roles: keycloak.realmAccess?.roles || []
  };
}; 