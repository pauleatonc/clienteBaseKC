import React from 'react';
import ClaveUnicaButton from './ClaveUnicaButton';

const AuthButtons = ({ 
  authenticated, 
  handleLogin, 
  handleLogout, 
  activeView, 
  onUserInfoClick, 
  loading
}) => {
  if (!authenticated) {
    return (
      <div className="mt-5">
        <ClaveUnicaButton onClick={handleLogin} />
      </div>
    );
  }

  return (
    <div className="d-grid gap-3" style={{ width: '300px' }}>
      <button 
        className={`btn ${activeView === 'userInfo' ? 'btn-success' : 'btn-primary'}`}
        onClick={onUserInfoClick}
      >
        Información JWT Keycloak
      </button>
      <button 
        className={`btn ${activeView === 'pesticides' ? 'btn-success' : 'btn-primary'}`}
        onClick={onPesticidesClick}
        disabled={loading}
      >
        {loading ? 'Cargando...' : 'Ejemplo de llamada a API'}
      </button>
      <button 
        className="btn btn-outline-primary" 
        onClick={handleLogout}
      >
        Cerrar Sesión
      </button>
    </div>
  );
};

export default AuthButtons; 