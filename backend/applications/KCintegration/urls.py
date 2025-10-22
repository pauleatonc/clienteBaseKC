from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views.test_views import TestView
from .views.pesticide_views import PesticideViewSet

# Configurar el router para ViewSets
router = DefaultRouter()
router.register(r'pesticides', PesticideViewSet, basename='pesticide')

urlpatterns = [
    path('api/', include(router.urls)),
    path('api/test/', TestView.as_view(), name='test'),
]