from django import forms
from django.contrib import admin
from django.contrib.admin.options import TabularInline
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin as BaseAdmin
from django.contrib.auth.forms import ReadOnlyPasswordHashField
from django.core.exceptions import ValidationError
from users.models import User
from files.models import Upload


class UploadInline(TabularInline):
    model = Upload
    extra = 0


class UserCreationForm(forms.ModelForm):
    password1 = forms.CharField(label='Password', widget=forms.PasswordInput)
    password2 = forms.CharField(label='Password confirmation', widget=forms.PasswordInput)

    class Meta:
        model = User
        fields = ('user_id', 'user_name', 'is_admin')

    def clean_password2(self):
        password1 = self.cleaned_data.get("password1")
        password2 = self.cleaned_data.get("password2")
        if password1 and password2 and password1 != password2:
            raise ValidationError("Passwords don't match")
        return password2

    def save(self, commit=True):
        user = super().save(commit=False)
        user.set_password(self.cleaned_data["password1"])
        if commit:
            user.save()
        return user


class UserChangeForm(forms.ModelForm):
    password = ReadOnlyPasswordHashField()

    class Meta:
        model = User
        fields = ('user_id', 'password', 'user_name', 'is_active', 'is_admin')


class UserAdmin(BaseAdmin):
    form = UserChangeForm
    add_form = UserCreationForm

    list_display = ('user_id', 'user_name', 'is_active', 'is_admin')
    list_filter = ('is_admin', 'is_active')
    search_fields = ('user_id',)
    ordering = ('user_id',)

    fieldsets = (
        ('Login info', {'fields': ('user_id', 'password',)}),
        ('Personal info', {'fields': ('user_name',)}),
        ('Activation', {'fields': ('is_active',)}),
        ('Permission', {'fields': ('is_admin',)}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('user_id', 'password1', 'password2', 'user_name', 'is_admin'),
        }),
    )
    
    inlines = [UploadInline]

    filter_horizontal = ()

admin.site.register(User, UserAdmin)
admin.site.unregister(Group)