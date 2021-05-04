from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader

def dashboard(request):
    template = loader.get_template('redonkulator_app/index.html')
    context = {}
    return HttpResponse(template.render(context, request))

def landing(request, *args, **kwargs):
    return render(request, 'landing.html')
