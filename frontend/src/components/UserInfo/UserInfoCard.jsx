import React from 'react';

const UserInfoCard = ({ userInfo }) => {
  if (!userInfo) return null;
  
  return (
    <div className="p-4 border rounded">
      <div className="mb-4">
        <h3 className="h5 mb-3 text-center">Información del Usuario</h3>
        <div className="d-flex flex-column gap-2">
          <div className="d-flex align-items-center gap-2 justify-content-center">
            <strong>Nombre:</strong>
            <span>{userInfo.name}</span>
          </div>
          <div className="d-flex align-items-center gap-2 justify-content-center">
            <strong>RUT:</strong>
            <span>{userInfo.rut}</span>
          </div>
          <div className="d-flex align-items-center gap-2 justify-content-center">
            <strong>Email:</strong>
            <span>{userInfo.email}</span>
          </div>
          <div className="d-flex align-items-center gap-2 justify-content-center">
            <strong>Nombre de Usuario Preferido:</strong>
            <span>{userInfo.preferred_username}</span>
          </div>
          <div className="d-flex align-items-center gap-2 justify-content-center">
            <strong>Roles:</strong>
            <span>{userInfo.roles.join(', ')}</span>
          </div>
        </div>
      </div>
      <AuthFlowDescription />
    </div>
  );
};

const AuthFlowDescription = () => {
  return (
    <div className="border-top pt-4">
      <h3 className="h5 mb-3 text-center">Flujo de Autenticación</h3>
      <div className="d-flex flex-column gap-2">
        <div className="d-flex align-items-center gap-2 justify-content-center">
          <span className="badge bg-primary">1</span>
          <span>Usuario inicia sesión con ClaveÚnica a través de Keycloak</span>
        </div>
        <div className="d-flex align-items-center gap-2 justify-content-center">
          <span className="badge bg-primary">2</span>
          <span>Keycloak valida las credenciales y genera un token JWT</span>
        </div>
        <div className="d-flex align-items-center gap-2 justify-content-center">
          <span className="badge bg-primary">3</span>
          <span>Frontend (cliente público) recibe el token y lo envía al backend</span>
        </div>
        <div className="d-flex align-items-center gap-2 justify-content-center">
          <span className="badge bg-primary">4</span>
          <span>Backend (cliente privado) valida el token con Keycloak</span>
        </div>
        <div className="d-flex align-items-center gap-2 justify-content-center">
          <span className="badge bg-primary">5</span>
          <span>Backend extrae la información del usuario del token</span>
        </div>
        <div className="d-flex align-items-center gap-2 justify-content-center">
          <span className="badge bg-primary">6</span>
          <span>Backend responde con los datos del usuario validados</span>
        </div>
      </div>
      <div className="mt-4 p-3 bg-light rounded text-center">
        <h4 className="h6 mb-2">¿Por qué tener clientes públicos y privados?</h4>
        <ul className="mb-0">
          <li><strong>Cliente Frontend (Público):</strong> Permite la autenticación desde cualquier navegador sin exponer credenciales sensibles</li>
          <li><strong>Cliente Backend (Privado):</strong> Mantiene las credenciales seguras y valida los tokens de forma segura</li>
          <li><strong>Seguridad:</strong> Separa las responsabilidades y reduce la superficie de ataque</li>
          <li><strong>Escalabilidad:</strong> Permite múltiples frontends mientras mantiene un único punto de validación</li>
        </ul>
      </div>
    </div>
  );
};

export default UserInfoCard; 