from django.urls import path

from . import views


urlpatterns = [
    path('signup/', views.SignUp), # 회원가입
    path('signin/', views.SignIn),                 # 로그인
    path('info/', views.UserView.as_view()),     # 유저조회/수정/삭제
]

