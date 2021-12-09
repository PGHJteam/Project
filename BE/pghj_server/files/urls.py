from django.urls import path
from . import views


urlpatterns = [
    path('upload/images/', views.ImageView.as_view()),   # Upload images
    path('create/pptx/', views.MaterialView.as_view()),  # Create pptx
    path('download/pptx/', views.DownloadView.as_view()) # Download pptx
]