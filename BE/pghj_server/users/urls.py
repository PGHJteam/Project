from inspect import Signature
from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from users import views


urlpatterns = [
    path('signup/', views.SignUp),                         # Sign Up
    path('signin/', TokenObtainPairView.as_view()),        # Login (Obtain Tokens)
    path('token/refresh/', TokenRefreshView.as_view()),    # Refresh Tokens
    path('info/', views.UserView.as_view()),               # Get/Update/Delete user-info
]