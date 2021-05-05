from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse
from django.http import Http404
from django.template import loader

from .models import Exercise


def dashboard(request):
    template = loader.get_template('redonkulator_app/index.html')
    context = {}
    return HttpResponse(template.render(context, request))


def landing(request, *args, **kwargs):
    exercise_list = Exercise.objects.order_by('-startdate')[:10]
    context = {
        'exercise_list': exercise_list
    }
    return render(request, 'landing.html', context)


def detail(request, exercise, *args, **kwargs):
    ex = get_object_or_404(Exercise, pk=exercise.exercise)
    return render(request, 'exercisedetail.html', {'exercise': ex})
