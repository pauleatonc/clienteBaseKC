import { useState, useEffect, useCallback } from 'react';
import { 
  initKeycloak, 
  login, 
  logout, 
  checkAuthStatus, 
  extractUserInfo,
  startTokenRotation,
  stopTokenRotation
} from '../services/keycloak';

/**
 * Hook personalizado para manejar la autenticación con Keycloak
 */
export const useAuth = () => {
  const [keycloak, setKeycloak] = useState(null);
  const [authenticated, setAuthenticated] = useState(false);
  const [userInfo, setUserInfo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [tokenRotationInterval, setTokenRotationInterval] = useState(null);

  // Inicializar Keycloak
  useEffect(() => {
    const initializeAuth = async () => {
      try {
        setLoading(true);
        setError(null);
        
        const { keycloak: kc, authenticated: isAuthenticated } = await initKeycloak();
        
        setKeycloak(kc);
        setAuthenticated(isAuthenticated);
        
        if (isAuthenticated) {
          const user = extractUserInfo(kc);
          setUserInfo(user);
          
          // Iniciar rotación automática de tokens
          const interval = startTokenRotation(kc);
          setTokenRotationInterval(interval);
        }
      } catch (err) {
        console.error('Error initializing auth:', err);
        setError(err?.message || 'Error de inicialización de autenticación');
      } finally {
        setLoading(false);
      }
    };

    initializeAuth();
  }, []);

  // Verificar estado de autenticación periódicamente
  useEffect(() => {
    if (!keycloak) return;

    const checkAuth = async () => {
      try {
        const authStatus = await checkAuthStatus(keycloak);
        setAuthenticated(authStatus.authenticated);
        setUserInfo(authStatus.userInfo);
        
        if (authStatus.authenticated && !tokenRotationInterval) {
          // Iniciar rotación automática si no está activa
          const interval = startTokenRotation(keycloak);
          setTokenRotationInterval(interval);
        } else if (!authStatus.authenticated && tokenRotationInterval) {
          // Detener rotación automática si no está autenticado
          stopTokenRotation(tokenRotationInterval);
          setTokenRotationInterval(null);
        }
      } catch (err) {
        console.error('Error checking auth status:', err);
        setError(err.message);
      }
    };

    // Verificar cada 30 segundos
    const interval = setInterval(checkAuth, 30000);
    
    return () => {
      clearInterval(interval);
      if (tokenRotationInterval) {
        stopTokenRotation(tokenRotationInterval);
      }
    };
  }, [keycloak, tokenRotationInterval]);

  // Función para iniciar sesión
  const handleLogin = useCallback(async () => {
    if (!keycloak) {
      setError('Keycloak no inicializado');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      await login(keycloak);
    } catch (err) {
      console.error('Error during login:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [keycloak]);

  // Función para cerrar sesión
  const handleLogout = useCallback(async () => {
    if (!keycloak) {
      setError('Keycloak no inicializado');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      
      // Detener rotación automática
      if (tokenRotationInterval) {
        stopTokenRotation(tokenRotationInterval);
        setTokenRotationInterval(null);
      }
      
      await logout(keycloak);
      setAuthenticated(false);
      setUserInfo(null);
    } catch (err) {
      console.error('Error during logout:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [keycloak, tokenRotationInterval]);

  // Función para mostrar información del usuario
  const handleUserInfoClick = useCallback(() => {
    // Esta función se puede personalizar según las necesidades
    console.log('User info clicked:', userInfo);
  }, [userInfo]);

  // Función para mostrar pesticidas
  const handlePesticidesClick = useCallback(() => {
    // Esta función se puede personalizar según las necesidades
    console.log('Pesticides clicked');
  }, []);

  return {
    keycloak,
    authenticated,
    userInfo,
    loading,
    error,
    handleLogin,
    handleLogout,
    handleUserInfoClick,
    handlePesticidesClick
  };
};
