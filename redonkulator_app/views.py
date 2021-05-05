from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse
from django.http import Http404
from django.template import loader

from .models import Exercise, Units


def dashboard(request):
    template = loader.get_template('redonkulator_app/index.html')
    context = {}
    return HttpResponse(template.render(context, request))


def landing(request, *args, **kwargs):
    exercise_list = Exercise.objects.order_by('-startdate')
    unit_list = Units.objects.order_by('-uic')
    context = {
        'exercise_list': exercise_list,
        'unit_list': unit_list
    }
    return render(request, 'landing.html', context)


def exercise_detail(request, exercise, *args, **kwargs):
    ex = get_object_or_404(Exercise, pk=exercise.exercise)
    return render(request, 'exercise/exercise_detail.html', {'exercise': ex})


def unit_detail(request, unit, *args, **kwargs):
    unt = get_object_or_404(Units, pk=unit.short_name)
    return render(request, 'unit/unit_detail.html', {'unit': unt})


def new_exercise(request, *args, **kwargs):
    return render(request, 'exercise/new_exercise.html')


def new_unit(request, *args, **kwargs):
    return render(request, 'unit/new_unit.html')
