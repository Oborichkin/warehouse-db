# Generated by Django 3.0.2 on 2020-01-04 17:27

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('wh', '0003_auto_20200104_2025'),
    ]

    operations = [
        migrations.AlterField(
            model_name='sales',
            name='certificate',
            field=models.ForeignKey(blank=True, on_delete=django.db.models.deletion.PROTECT, to='wh.Sales'),
        ),
    ]
