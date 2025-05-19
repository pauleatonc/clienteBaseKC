"""
Production settings for clientebase project.
"""
from .base import *
import os
from dotenv import load_dotenv

# Cargar variables de entorno de producción
load_dotenv(os.path.join(BASE_DIR, '.env.prod'))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '').split(',')

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_DB_PROD'),
        'USER': os.environ.get('POSTGRES_USER_PROD'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD_PROD'),
        'HOST': os.environ.get('POSTGRES_HOST_PROD'),
        'PORT': os.environ.get('POSTGRES_PORT_PROD'),
    }
}

# Keycloak settings
KEYCLOAK_URL = os.environ.get('KEYCLOAK_URL_PROD')
KEYCLOAK_REALM = os.environ.get('KEYCLOAK_REALM_PROD')
KEYCLOAK_CLIENT_ID = os.environ.get('KEYCLOAK_CLIENT_ID_PROD')
KEYCLOAK_CLIENT_SECRET = os.environ.get('KEYCLOAK_CLIENT_SECRET_PROD')
KEYCLOAK_VERIFY_SSL = os.environ.get('KEYCLOAK_VERIFY_SSL_PROD', 'True').lower() == 'true'

# CORS settings específicas para producción
CORS_ALLOW_ALL_ORIGINS = False
CORS_ALLOWED_ORIGINS = os.environ.get('CORS_ALLOWED_ORIGINS', '').split(',')

# Security settings
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
SECURE_HSTS_SECONDS = 31536000  # 1 año
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True 