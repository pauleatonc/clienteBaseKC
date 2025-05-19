"""
ASGI config for clientebase project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/howto/deployment/asgi/
"""

import os

from django.applications.KCintegration.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'clientebase.settings')

application = get_asgi_application()
