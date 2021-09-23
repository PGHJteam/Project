from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from . import views


urlpatterns = [
    path('signup/', views.SignUp),                         # 회원가입
    path('signin/', TokenObtainPairView.as_view()),        # 로그인 (토큰 발급)
    path('token/refresh/', TokenRefreshView.as_view()),    # 토큰 갱신
    path('info/', views.UserView.as_view()),               # 유저조회/수정/삭제
]