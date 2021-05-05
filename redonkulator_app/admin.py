from django.contrib import admin

# Register your models here.

from . import models

admin.site.register(models.Exercise)

admin.site.register(models.Units)
