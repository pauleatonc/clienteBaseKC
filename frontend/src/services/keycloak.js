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
      onLoad: null,
      pkceMethod: 'S256',
      checkLoginIframe: false,
      redirectUri: window.location.origin + window.location.pathname
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
 */
const setupAxiosInterceptors = (keycloakClient) => {
  axios.interceptors.request.use(
    (config) => {
      if (keycloakClient.authenticated && keycloakClient.token) {
        config.headers.Authorization = `Bearer ${keycloakClient.token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );
};

/**
 * Inicia sesión en Keycloak
 */
export const login = (keycloak) => {
  if (keycloak) {
    return keycloak.login({
      redirectUri: window.location.origin + window.location.pathname,
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
      redirectUri: window.location.origin + window.location.pathname
    });
  }
  return Promise.reject('Keycloak no inicializado');
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