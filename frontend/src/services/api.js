import axios from 'axios';

const API_URL = 'http://localhost:8000/api';

/**
 * Intercambia el token de Keycloak por un token de backend
 */
export const exchangeToken = async (keycloakToken) => {
  try {
    const response = await axios.post(`${API_URL}/auth/token/`, null, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${keycloakToken}`
      },
      withCredentials: true
    });
    return response.data.token;
  } catch (error) {
    console.error('Error exchanging token:', error);
    throw error;
  }
};

/**
 * Obtiene información del usuario autenticado
 */
export const fetchUserData = async (backendToken) => {
  try {
    const response = await axios.get(`${API_URL}/test/`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${backendToken}`
      },
      withCredentials: true
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching user data:', error);
    throw error;
  }
};

/**
 * Obtiene la lista de pesticidas
 */
export const fetchPesticides = async (backendToken) => {
  try {
    const response = await axios.get(`${API_URL}/pesticides/`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${backendToken}`
      },
      withCredentials: true
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching pesticides:', error);
    throw error;
  }
}; 