from django.urls import path

from . import views

urlpatterns = [
    path('', views.landing),
    # ex: /Cobra Gold/
    path('exercise/<str:exercise>/', views.detail),
]
