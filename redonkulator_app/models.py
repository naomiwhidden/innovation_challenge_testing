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

class Locations(models.Model):
    location = models.CharField(max_length=45)

    def __str__(self):
        return f"{self.location}"

class Users(models.Model):
    email = models.CharField(max_length=45, unique=True)
    edipi = models.IntegerField(primary_key=True)
    display_name = models.CharField(max_length=45)
    phone = models.CharField(max_length=45)


    def __str__(self):
        return f"User: {self.display_name}\tEDIPI: {self.edipi}\tEmail: {self.email}\tPhone: {self.phone}"

class Units(models.Model):
    uic = models.CharField(max_length=20, primary_key=True)
    short_name = models.CharField(max_length=45, unique=True)
    long_name = models.CharField(max_length=100, unique=True)
    mcc = models.CharField(max_length=45, unique=True)
    ruc = models.CharField(max_length=45, unique=True)
    type = models.CharField(max_length=45, unique=True)

    def __str__(self):
        return f"UIC: {self.uic}\tName: {self.short_name}"