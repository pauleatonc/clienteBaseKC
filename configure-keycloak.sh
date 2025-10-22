#!/bin/bash

echo "Configurando Keycloak..."

# Esperar a que Keycloak esté listo
echo "Esperando a que Keycloak esté disponible..."
until curl -sf http://localhost:8080/realms/master > /dev/null 2>&1; do
    echo "Esperando..."
    sleep 2
done

echo "Keycloak está disponible!"

# Obtener token de administración
echo "Obteniendo token de administración..."
ADMIN_TOKEN=$(curl -s -X POST http://localhost:8080/realms/master/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin" \
  -d "password=admin" \
  -d "grant_type=password" \
  -d "client_id=admin-cli" | jq -r '.access_token')

if [ -z "$ADMIN_TOKEN" ] || [ "$ADMIN_TOKEN" == "null" ]; then
    echo "Error: No se pudo obtener el token de administración"
    exit 1
fi

echo "Token obtenido exitosamente!"

# Verificar si el realm 'test' existe
echo "Verificando realm 'test'..."
REALM_EXISTS=$(curl -s -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:8080/admin/realms/test | jq -r '.realm')

if [ "$REALM_EXISTS" != "test" ]; then
    echo "Creando realm 'test'..."
    curl -s -X POST http://localhost:8080/admin/realms \
      -H "Authorization: Bearer $ADMIN_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "realm": "test",
        "enabled": true,
        "registrationAllowed": false
      }'
    echo "Realm 'test' creado!"
else
    echo "Realm 'test' ya existe!"
fi

# Verificar si el cliente 'frontintegration' existe
echo "Verificando cliente 'frontintegration'..."
CLIENT_ID=$(curl -s -H "Authorization: Bearer $ADMIN_TOKEN" \
  "http://localhost:8080/admin/realms/test/clients?clientId=frontintegration" | jq -r '.[0].id')

if [ -z "$CLIENT_ID" ] || [ "$CLIENT_ID" == "null" ]; then
    echo "Creando cliente 'frontintegration'..."
    curl -s -X POST http://localhost:8080/admin/realms/test/clients \
      -H "Authorization: Bearer $ADMIN_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "clientId": "frontintegration",
        "enabled": true,
        "publicClient": true,
        "protocol": "openid-connect",
        "directAccessGrantsEnabled": false,
        "standardFlowEnabled": true,
        "implicitFlowEnabled": false,
        "redirectUris": [
          "http://localhost:5173/*",
          "http://localhost:3000/*"
        ],
        "webOrigins": [
          "http://localhost:5173",
          "http://localhost:3000",
          "+"
        ],
        "attributes": {
          "pkce.code.challenge.method": "S256"
        }
      }'
    echo "Cliente 'frontintegration' creado!"
else
    echo "Cliente 'frontintegration' ya existe! Actualizando configuración..."
    curl -s -X PUT "http://localhost:8080/admin/realms/test/clients/$CLIENT_ID" \
      -H "Authorization: Bearer $ADMIN_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "clientId": "frontintegration",
        "enabled": true,
        "publicClient": true,
        "protocol": "openid-connect",
        "directAccessGrantsEnabled": false,
        "standardFlowEnabled": true,
        "implicitFlowEnabled": false,
        "redirectUris": [
          "http://localhost:5173/*",
          "http://localhost:3000/*"
        ],
        "webOrigins": [
          "http://localhost:5173",
          "http://localhost:3000",
          "+"
        ],
        "attributes": {
          "pkce.code.challenge.method": "S256"
        }
      }'
    echo "Cliente 'frontintegration' actualizado!"
fi

echo "¡Configuración completada exitosamente!"

