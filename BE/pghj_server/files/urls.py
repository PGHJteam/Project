from django.urls import path
from django.conf import settings
from django.conf.urls.static import static

from . import views


urlpatterns = [
    path('uploadImages/', views.ImageView.as_view()), # 이미지 업로드 
    path('download/pptx/', views.MaterialView.as_view())
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

