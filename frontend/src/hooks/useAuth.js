import { useState, useEffect, useCallback } from 'react';
import { initKeycloak, login, logout, extractUserInfo } from '../services/keycloak';
import { exchangeToken, fetchUserData } from '../services/api';

export const useAuth = () => {
  const [keycloak, setKeycloak] = useState(null);
  const [authenticated, setAuthenticated] = useState(false);
  const [isInitialized, setIsInitialized] = useState(false);
  const [error, setError] = useState('');
  const [userInfo, setUserInfo] = useState(null);
  const [backendToken, setBackendToken] = useState(null);

  // Inicializar Keycloak
  useEffect(() => {
    const initialize = async () => {
      try {
        const { keycloak: keycloakClient, authenticated: authStatus } = await initKeycloak();
        setKeycloak(keycloakClient);
        setAuthenticated(authStatus);
        setIsInitialized(true);
        
        // Si está autenticado, extraer información del usuario
        if (authStatus) {
          const userInfo = extractUserInfo(keycloakClient);
          setUserInfo(userInfo);
          
          // Obtener token de backend
          try {
            const token = await exchangeToken(keycloakClient.token);
            setBackendToken(token);
          } catch (err) {
            console.error('Error exchanging token:', err);
          }
        }
      } catch (error) {
        console.error('Auth initialization error:', error);
        setError('Error al inicializar la autenticación');
        setIsInitialized(true);
      }
    };

    initialize();
  }, []);

  // Función para iniciar sesión
  const handleLogin = useCallback(() => {
    if (keycloak) {
      try {
        login(keycloak).catch(error => {
          console.error('Login error:', error);
          setError('Error al iniciar sesión');
        });
      } catch (error) {
        console.error('Login error:', error);
        setError('Error al iniciar sesión');
      }
    }
  }, [keycloak]);

  // Función para cerrar sesión
  const handleLogout = useCallback(() => {
    if (keycloak) {
      try {
        logout(keycloak).catch(error => {
          console.error('Logout error:', error);
          setError('Error al cerrar sesión');
        });
      } catch (error) {
        console.error('Logout error:', error);
        setError('Error al cerrar sesión');
      }
    }
  }, [keycloak]);

  // Función para obtener datos protegidos
  const fetchProtectedData = useCallback(async () => {
    if (!keycloak || !authenticated) return null;
    
    try {
      // Si no tenemos token de backend, obtenerlo
      let token = backendToken;
      if (!token) {
        token = await exchangeToken(keycloak.token);
        setBackendToken(token);
      }
      
      // Obtener datos del usuario
      const userData = await fetchUserData(token);
      return userData;
    } catch (error) {
      console.error('Error fetching protected data:', error);
      setError('Error al obtener datos protegidos');
      
      // Si recibimos un 401, intentar renovar el token
      if (error.response?.status === 401) {
        handleLogin();
      }
      return null;
    }
  }, [keycloak, authenticated, backendToken, handleLogin]);

  return {
    keycloak,
    authenticated,
    isInitialized,
    error,
    userInfo,
    backendToken,
    handleLogin,
    handleLogout,
    fetchProtectedData
  };
}; 