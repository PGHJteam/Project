from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager


class UserManager(BaseUserManager):
    def create_user(self, user_id, user_name, password=None):
        if not user_id:
            raise ValueError('Users must have an ID')
        if not user_name:
            raise ValueError('Users must have a NAME')

        user = self.model(
            user_id=user_id,
            user_name=user_name,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, user_id, user_name, password=None):
        user = self.create_user(
            user_id=user_id,
            password=password,
            user_name=user_name,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class User(AbstractBaseUser):
    #password
    user_id = models.CharField("ID", max_length=20, unique=True)
    user_name = models.CharField("Name", max_length=20)
    created_at = models.DateTimeField("Created at", auto_now_add=True)
    is_active = models.BooleanField("Is active", default=True)
    is_admin = models.BooleanField("Is admin", default=False)

    objects = UserManager()

    USERNAME_FIELD = 'user_id'
    REQUIRED_FIELDS = ['user_name']
    
    class Meta:
        db_table = "users"
        
    def __str__(self):
        return self.user_id

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    @property
    def is_staff(self):
        return self.is_admin