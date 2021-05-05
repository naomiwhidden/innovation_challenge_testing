from django.shortcuts import render

# Create your views here.

def about(request):
    return render(request, 'about.html')

def account(request):
    return render(request, 'account.html')