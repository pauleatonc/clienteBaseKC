from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import logging

logger = logging.getLogger(__name__)

class TestView(APIView):
    """
    Vista de prueba para verificar la autenticación y obtener información del usuario
    """
    
    def get(self, request):
        """
        Retorna información del usuario autenticado y datos de prueba
        """
        try:
            # Obtener información del usuario desde el middleware
            user_info = getattr(request, 'user_info', {})
            user_roles = getattr(request, 'user_roles', [])
            
            # Datos de respuesta
            response_data = {
                'message': 'API funcionando correctamente',
                'user': {
                    'sub': user_info.get('sub', 'No disponible'),
                    'preferred_username': user_info.get('preferred_username', 'No disponible'),
                    'email': user_info.get('email', 'No disponible'),
                    'name': user_info.get('name', 'No disponible'),
                    'given_name': user_info.get('given_name', 'No disponible'),
                    'family_name': user_info.get('family_name', 'No disponible')
                },
                'roles': user_roles,
                'timestamp': request.META.get('HTTP_DATE', 'No disponible'),
                'user_agent': request.META.get('HTTP_USER_AGENT', 'No disponible'),
                'ip_address': request.META.get('REMOTE_ADDR', 'No disponible')
            }
            
            logger.info(f"Test endpoint accessed by user: {user_info.get('preferred_username', 'unknown')}")
            
            return Response(response_data, status=status.HTTP_200_OK)
            
        except Exception as e:
            logger.error(f"Error in TestView: {str(e)}")
            return Response(
                {'error': 'Error interno del servidor'}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
