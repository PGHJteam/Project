from django.urls import path
from django.conf import settings
from django.conf.urls.static import static

from . import views


urlpatterns = [
    path('', views.FileView.as_view()), # 이미지 업로드 
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

