from django.urls import path

from . import views

urlpatterns = [
    path('', views.landing),
    path('newexercise/', views.new_exercise),
    path('newunit/', views.new_unit),
    # ex: exercise/Cobra Gold/
    path('exercise/<str:exercise>/', views.exercise_detail),
    # ex: unit/7th Comm/
    path('unit/<str:short_name>/', views.unit_detail),
]
