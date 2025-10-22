import axios from 'axios';

const API_URL = 'http://localhost:8000/api';

/**
 * Obtiene información del usuario autenticado
 * Usa directamente el access_token de Keycloak
 */
export const fetchUserData = async () => {
  try {
    const response = await axios.get(`${API_URL}/test/`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
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
 * Usa directamente el access_token de Keycloak
 */
export const fetchPesticides = async () => {
  try {
    const response = await axios.get(`${API_URL}/pesticides/`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      withCredentials: true
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching pesticides:', error);
    throw error;
  }
}; 