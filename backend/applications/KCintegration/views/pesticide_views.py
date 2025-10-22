from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
import logging

logger = logging.getLogger(__name__)

class PesticideViewSet(viewsets.ViewSet):
    """
    ViewSet para manejar operaciones relacionadas con pesticidas
    """
    
    def list(self, request):
        """
        Retorna la lista de pesticidas disponibles
        """
        try:
            # Datos de ejemplo de pesticidas
            pesticides_data = [
                {
                    'id': 1,
                    'name': 'Glifosato',
                    'type': 'Herbicida',
                    'active_ingredient': 'N-(fosfonometil)glicina',
                    'concentration': '480 g/L',
                    'manufacturer': 'Monsanto',
                    'registration_number': 'REG-001-2024',
                    'status': 'Activo',
                    'restrictions': ['No aplicar en días ventosos', 'Mantener distancia de 10m de cursos de agua']
                },
                {
                    'id': 2,
                    'name': 'Atrazina',
                    'type': 'Herbicida',
                    'active_ingredient': '2-cloro-4-etilamino-6-isopropilamino-1,3,5-triazina',
                    'concentration': '500 g/L',
                    'manufacturer': 'Syngenta',
                    'registration_number': 'REG-002-2024',
                    'status': 'Activo',
                    'restrictions': ['Solo para uso agrícola', 'No aplicar en suelos arenosos']
                },
                {
                    'id': 3,
                    'name': 'Clorpirifos',
                    'type': 'Insecticida',
                    'active_ingredient': 'O,O-dietil O-3,5,6-tricloro-2-piridil fosforotioato',
                    'concentration': '480 g/L',
                    'manufacturer': 'Dow AgroSciences',
                    'registration_number': 'REG-003-2024',
                    'status': 'Restringido',
                    'restrictions': ['Solo para uso profesional', 'Equipo de protección personal obligatorio']
                },
                {
                    'id': 4,
                    'name': 'Mancozeb',
                    'type': 'Fungicida',
                    'active_ingredient': 'Manganeso + Zinc + Etilenobis(ditiocarbamato)',
                    'concentration': '800 g/kg',
                    'manufacturer': 'Bayer',
                    'registration_number': 'REG-004-2024',
                    'status': 'Activo',
                    'restrictions': ['Intervalo de seguridad de 7 días', 'No mezclar con productos alcalinos']
                },
                {
                    'id': 5,
                    'name': 'Imidacloprid',
                    'type': 'Insecticida',
                    'active_ingredient': '1-(6-cloro-3-piridilmetil)-N-nitroimidazolidin-2-ilidenamina',
                    'concentration': '200 g/L',
                    'manufacturer': 'Bayer',
                    'registration_number': 'REG-005-2024',
                    'status': 'Activo',
                    'restrictions': ['Tóxico para abejas', 'No aplicar durante floración']
                }
            ]
            
            # Obtener información del usuario para logging
            user_info = getattr(request, 'user_info', {})
            username = user_info.get('preferred_username', 'unknown')
            
            logger.info(f"Pesticides list accessed by user: {username}")
            
            return Response({
                'pesticides': pesticides_data,
                'total': len(pesticides_data),
                'message': 'Lista de pesticidas obtenida exitosamente'
            }, status=status.HTTP_200_OK)
            
        except Exception as e:
            logger.error(f"Error in PesticideViewSet.list: {str(e)}")
            return Response(
                {'error': 'Error interno del servidor'}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    def retrieve(self, request, pk=None):
        """
        Retorna información detallada de un pesticida específico
        """
        try:
            # Datos de ejemplo para un pesticida específico
            pesticide_data = {
                'id': int(pk),
                'name': 'Glifosato',
                'type': 'Herbicida',
                'active_ingredient': 'N-(fosfonometil)glicina',
                'concentration': '480 g/L',
                'manufacturer': 'Monsanto',
                'registration_number': 'REG-001-2024',
                'status': 'Activo',
                'restrictions': ['No aplicar en días ventosos', 'Mantener distancia de 10m de cursos de agua'],
                'description': 'Herbicida no selectivo de amplio espectro, efectivo contra malezas anuales y perennes.',
                'application_rate': '2-4 L/ha',
                'pre_harvest_interval': '7 días',
                're_entry_interval': '12 horas',
                'toxicity_class': 'Clase II - Moderadamente tóxico',
                'environmental_impact': 'Baja persistencia en suelo, degradación microbiana'
            }
            
            user_info = getattr(request, 'user_info', {})
            username = user_info.get('preferred_username', 'unknown')
            
            logger.info(f"Pesticide {pk} details accessed by user: {username}")
            
            return Response(pesticide_data, status=status.HTTP_200_OK)
            
        except ValueError:
            return Response(
                {'error': 'ID de pesticida inválido'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        except Exception as e:
            logger.error(f"Error in PesticideViewSet.retrieve: {str(e)}")
            return Response(
                {'error': 'Error interno del servidor'}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    @action(detail=False, methods=['get'])
    def search(self, request):
        """
        Busca pesticidas por nombre o tipo
        """
        try:
            query = request.query_params.get('q', '').lower()
            
            # Datos de ejemplo (mismos que en list)
            all_pesticides = [
                {
                    'id': 1,
                    'name': 'Glifosato',
                    'type': 'Herbicida',
                    'active_ingredient': 'N-(fosfonometil)glicina',
                    'concentration': '480 g/L',
                    'manufacturer': 'Monsanto',
                    'registration_number': 'REG-001-2024',
                    'status': 'Activo'
                },
                {
                    'id': 2,
                    'name': 'Atrazina',
                    'type': 'Herbicida',
                    'active_ingredient': '2-cloro-4-etilamino-6-isopropilamino-1,3,5-triazina',
                    'concentration': '500 g/L',
                    'manufacturer': 'Syngenta',
                    'registration_number': 'REG-002-2024',
                    'status': 'Activo'
                },
                {
                    'id': 3,
                    'name': 'Clorpirifos',
                    'type': 'Insecticida',
                    'active_ingredient': 'O,O-dietil O-3,5,6-tricloro-2-piridil fosforotioato',
                    'concentration': '480 g/L',
                    'manufacturer': 'Dow AgroSciences',
                    'registration_number': 'REG-003-2024',
                    'status': 'Restringido'
                },
                {
                    'id': 4,
                    'name': 'Mancozeb',
                    'type': 'Fungicida',
                    'active_ingredient': 'Manganeso + Zinc + Etilenobis(ditiocarbamato)',
                    'concentration': '800 g/kg',
                    'manufacturer': 'Bayer',
                    'registration_number': 'REG-004-2024',
                    'status': 'Activo'
                },
                {
                    'id': 5,
                    'name': 'Imidacloprid',
                    'type': 'Insecticida',
                    'active_ingredient': '1-(6-cloro-3-piridilmetil)-N-nitroimidazolidin-2-ilidenamina',
                    'concentration': '200 g/L',
                    'manufacturer': 'Bayer',
                    'registration_number': 'REG-005-2024',
                    'status': 'Activo'
                }
            ]
            
            # Filtrar por query
            if query:
                filtered_pesticides = [
                    p for p in all_pesticides 
                    if query in p['name'].lower() or 
                       query in p['type'].lower() or 
                       query in p['active_ingredient'].lower()
                ]
            else:
                filtered_pesticides = all_pesticides
            
            user_info = getattr(request, 'user_info', {})
            username = user_info.get('preferred_username', 'unknown')
            
            logger.info(f"Pesticides search '{query}' by user: {username}")
            
            return Response({
                'pesticides': filtered_pesticides,
                'total': len(filtered_pesticides),
                'query': query,
                'message': f'Búsqueda completada para: "{query}"'
            }, status=status.HTTP_200_OK)
            
        except Exception as e:
            logger.error(f"Error in PesticideViewSet.search: {str(e)}")
            return Response(
                {'error': 'Error interno del servidor'}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
