# -*- coding:Utf-8 -*-

from django.conf import settings
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.db import models
from django.utils import timezone


__all__ = (
    'User',
)


class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField('email address', max_length=254, unique=True)
    first_name = models.CharField('first name', max_length=30, blank=True)
    last_name = models.CharField('last name', max_length=30, blank=True)
    is_staff = models.BooleanField('staff status', default=False, help_text='Designates whether the user can log into this admin site.')
    is_active = models.BooleanField('active', default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.')
    date_joined = models.DateTimeField('date joined', default=timezone.now)
    browser_language = models.CharField('browser language', max_length=5, choices=settings.LANGUAGES, blank=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    class Meta:
        app_label = 'account'

    def get_full_name(self):
        """Returns the first_name plus the last_name, with a space in between."""
        full_name = '%s %s' % (self.first_name, self.last_name)
        return full_name.strip()

    def get_short_name(self):
        """Returns the short name for the user."""
        return self.first_name

    def has_identity_set(self):
        if self.first_name and self.last_name:
            return True
        return False
