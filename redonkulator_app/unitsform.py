from django.forms import ModelForm
from .models import Units

#Create the form class. 
class UnitsForm(ModelForm):
    class Meta:
        model = Units 
        fields = '__all__'

