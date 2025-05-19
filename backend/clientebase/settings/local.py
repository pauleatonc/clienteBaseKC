"""
Local settings for clientebase project.
"""
from .base import *
import os
from dotenv import load_dotenv

# Cargar variables de entorno locales
load_dotenv(os.path.join(BASE_DIR, '.env.local'))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY', 'django-insecure-c@nvi41l=&hiliox#f&*y)^2ka8(9b%@j-*#p8m=raq#vmf-u8')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_DB_LOCAL', 'clientebase'),
        'USER': os.environ.get('POSTGRES_USER_LOCAL', 'clientebase'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD_LOCAL', 'clientebase123'),
        'HOST': os.environ.get('POSTGRES_HOST_LOCAL', 'postgres'),
        'PORT': os.environ.get('POSTGRES_PORT_LOCAL', '5432'),
    }
}

# Keycloak settings
KEYCLOAK_URL = os.environ.get('KEYCLOAK_URL_LOCAL', 'http://keycloak:8080')
KEYCLOAK_REALM = os.environ.get('KEYCLOAK_REALM_LOCAL', 'test')
KEYCLOAK_CLIENT_ID = os.environ.get('KEYCLOAK_CLIENT_ID_LOCAL', 'backintegration')
KEYCLOAK_CLIENT_SECRET = os.environ.get('KEYCLOAK_CLIENT_SECRET_LOCAL', 'nmdnDct5SE0Tv6AllEmE2HnuYkdA2a1w')
KEYCLOAK_VERIFY_SSL = os.environ.get('KEYCLOAK_VERIFY_SSL_LOCAL', 'False').lower() == 'true'

# CORS settings específicas para local
CORS_ALLOW_ALL_ORIGINS = True 