"""
Development settings for clientebase project.
"""
from .base import *
import os
from dotenv import load_dotenv

# Cargar variables de entorno de desarrollo
load_dotenv(os.path.join(BASE_DIR, '.env.dev'))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '*').split(',')

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_DB_DEV'),
        'USER': os.environ.get('POSTGRES_USER_DEV'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD_DEV'),
        'HOST': os.environ.get('POSTGRES_HOST_DEV'),
        'PORT': os.environ.get('POSTGRES_PORT_DEV'),
    }
}

# Keycloak settings
KEYCLOAK_URL = os.environ.get('KEYCLOAK_URL_DEV')
KEYCLOAK_REALM = os.environ.get('KEYCLOAK_REALM_DEV')
KEYCLOAK_CLIENT_ID = os.environ.get('KEYCLOAK_CLIENT_ID_DEV')
KEYCLOAK_CLIENT_SECRET = os.environ.get('KEYCLOAK_CLIENT_SECRET_DEV')
KEYCLOAK_VERIFY_SSL = os.environ.get('KEYCLOAK_VERIFY_SSL_DEV', 'False').lower() == 'true'

# CORS settings específicas para desarrollo
CORS_ALLOW_ALL_ORIGINS = False
CORS_ALLOWED_ORIGINS = os.environ.get('CORS_ALLOWED_ORIGINS', 'http://localhost:5173').split(',') 