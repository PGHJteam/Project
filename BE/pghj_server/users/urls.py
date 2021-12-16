from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from users import views


urlpatterns = [
    path('signup/', views.SignUpView.as_view()),           # Sign Up
    path('signin/', TokenObtainPairView.as_view()),        # Login (Obtain Tokens)
    path('signout/', views.SignOutView.as_view()),         # Logout (Remove all outstanding tokens)
    path('token/refresh/', TokenRefreshView.as_view()),    # Refresh Tokens
    path('history/', views.HistoryView.as_view()),         # User history
]