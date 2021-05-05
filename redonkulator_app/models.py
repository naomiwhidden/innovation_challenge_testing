from django.db import models

class Exercise(models.Model):
    exercise = models.CharField(max_length=45, unique=True, primary_key=True)
    evolution = models.CharField(max_length=8, unique=True)
    startdate = models.DateField()
    enddate = models.DateField()
    logo =  models.BinaryField()

    def __str__(self):
        return f"Exercise: {self.exercise}\t Evolution: {self.evolution}"

class Locations(models.Model):
    location = models.CharField(max_length=45)

    def __str__(self):
        return f"{self.location}"

class Users(models.Model):
    email = models.EmailField(max_length=45, unique=True)
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
"""
class Permissions(models.Model):
    unit = models.ForeignKey(Units, on_delete=models.PROTECT)
    exercise_id = models.ForeignKey(Exercise, on_delete=models.PROTECT)
    # Is this actually needed?
    parent_user_id = models.ForeignKey(Users, on_delete=models.PROTECT)
    # Should this be 'users' and a Many-to-One relationship?
    user = models.ForeignKey(Users, on_delete=models.PROTECT)

    def __str__(self):
        return f"Permission: {self.exercise}\tUser: {self.user}"

class ExercisePersonnel(models.Model):
    unit = models.ForeignKey(Units, on_delete=models.PROTECT)
    exercise = models.ForeignKey(Exercise, on_delete=models.PROTECT)
    # Is this actually needed?
    location = models.ForeignKey(Locations, on_delete=models.PROTECT)
    # Should this be 'users' and a Many to One relationship?
    quantity = models.IntegerField()

    def __str__(self):
        return f"Exercise Personnel: {self.exercise}\tUser: {self.user}\tQuantity: {self.quantity}"

class Equipment(models.Model):
    tamcn = models.CharField(max_length=16, unique=True)
    nomen = models.CharField(max_length=45)
    type = models.CharField(max_length=45)
    length = models.DecimalField(decimal_places=2,max_digits=8)
    width = models.DecimalField(decimal_places=2,max_digits=8)
    height = models.DecimalField(decimal_places=2,max_digits=8)
    sqft = models.DecimalField(decimal_places=2,max_digits=8)
    cuft = models.DecimalField(decimal_places=2,max_digits=8)
    gvw_combat_loaded = models.DecimalField(decimal_places=2,max_digits=8)
    burn_rate = models.DecimalField(decimal_places=2,max_digits=8)
    burn_rate = models.IntegerField()
    passengers = models.IntegerField()
    fuel_payload = models.DecimalField(decimal_places=2,max_digits=8)
    water_payload = models.DecimalField(decimal_places=2,max_digits=8)
    payload = models.DecimalField(decimal_places=2,max_digits=8)
    pallets_palcons = models.IntegerField()
    sicon_transpo = models.IntegerField()
    quadcon = models.IntegerField()
    isocon = models.IntegerField()
    combat_load_pallet = models.IntegerField()
    combat_load_pallet_wt = models.DecimalField(decimal_places=2,max_digits=8)
    aslt_rate_pallet = models.DecimalField(decimal_places=2,max_digits=8)
    aslt_rate_pallet_wt = models.DecimalField(decimal_places=2,max_digits=8)
    sustain_rate_pallet = models.DecimalField(decimal_places=2,max_digits=8)
    sustain_rate_pallet_wt = models.DecimalField(decimal_places=2,max_digits=8)

    def __str__(self):
        return f"TAMCN: {self.tamcn}\tNOMEN: {self.nomen}"

class UnitEdl(models.Model):
    unit = models.ForeignKey(Units, on_delete=models.PROTECT)
    equipment = models.ForeignKey(Equipment, on_delete=models.PROTECT)
    quantity = models.IntegerField()

    def __str__(self):
        return f"Unit: {self.unit}\t Equipment: {self.equipment}\t Quan: {self.quantity}"

class ExerciseEdl(models.Model):
    unit = models.ForeignKey(Units, on_delete=models.PROTECT)
    # adjusted name from the reference
    exercise = models.ForeignKey(Exercise, on_delete=models.PROTECT)
    equipment = models.ForeignKey(Equipment, on_delete=models.PROTECT)
    quantity = models.IntegerField()
    location = models.ForeignKey(Locations, on_delete=models.PROTECT)

    def __str__(self):
        return f"Exercise: {self.exercise}\t Equipment: {self.equipment}\tQuantity: {self.quantity}"

class GenericEdl(models.Model):
    unit_type = models.ForeignKey(Units, unique=True, on_delete=models.PROTECT)
    equipment = models.ForeignKey(Equipment, unique=True, on_delete=models.PROTECT)
    quantity = models.IntegerField()

    def __str__(self):
        return f"Exercise: {self.exercise}\t Equipment: {self.equipment}\tQuantity: {self.quantity}"


class Climates(models.Model):
    climate = models.CharField(max_length=45)

    def __str__(self):
        return f"Climate: {self.climate}"

class AfterActions(models.Model):
    exercise = models.ForeignKey(Exercise, on_delete=models.PROTECT)
    # Will this store data the way we think?
    data = models.BinaryField()

    def __str__(self):
        return f"Data: {self.data}"

class AuditActions(models.Model):
    dtg = models.DateTimeField()
    user = models.ForeignKey(Users, on_delete=models.PROTECT)
    table_name = models.CharField(max_length=45)
    row_id = models.IntegerField()
    action = models.CharField(max_length=255)

    def __str__(self):
        r = f"Who: {self.user}\n"
        r = r + f"When: {self.dtg}\n"
        r = r + f"Where: {self.row_id} in table {self.table_name}\n"
        r = r + f"What: {self.action}\n"
        return r

class ExerciseUnitPlanningFactors(models.Model):
    unit = models.ForeignKey(Units, on_delete=models.PROTECT)
    exercise = models.ForeignKey(Exercise, on_delete=models.PROTECT)
    climate = models.ForeignKey(Climates, on_delete=models.PROTECT)
    aslt_rom = models.IntegerField()
    aslt_op_hours = models.IntegerField()
    sustain_rom = models.IntegerField()
    sustain_op_hours = models.IntegerField()
    min_class_one_water_gal = models.DecimalField(decimal_places=1,max_digits=4)
    sustain_class_one_water_gals = models.DecimalField(decimal_places=1,max_digits=4)

    def __str__(self):
        return f"Unit: {self.unit}\t Exercise: {self.exercise}\t Climate: {self.climate}"
"""