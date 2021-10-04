from django.urls import path

from . import views


urlpatterns = [
    path('upload/images/', views.ImageView.as_view()),   # Upload images
    path('download/pptx/', views.MaterialView.as_view()) # Create/Download pptx
]