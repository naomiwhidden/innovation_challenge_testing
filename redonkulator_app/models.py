from django.db import models

# Create your models here.

class Exercise(models.Model):
    name = models.CharField(max_length=20)
    pax = models.IntegerField()
    startdate = models.DateField()
    enddate = models.DateField()
    update = models.DateTimeField(auto_now_add=True)
    note = models.TextField(default="notes")

    def __str__(self):
        return f"{self.name}"
