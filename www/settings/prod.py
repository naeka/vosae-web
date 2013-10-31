# -*- coding:Utf-8 -*-
import os
import urlparse

from settings.base import *


DEBUG = False
TEMPLATE_DEBUG = DEBUG

# The secret key is different on every env for maximum security
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY')

# DATABASE CONFIGURATION SHOULD BE DEFINED HERE:
# MYSQL EXAMPLE:

# MYSQL DATABASE
# mysql_url = urlparse.urlparse(os.getenv('MYSQL_DATABASE_URL'))
# DATABASES['default'] = {
#     'ENGINE': 'django.db.backends.mysql',
#     'HOST': mysql_url.hostname,
#     'USER': mysql_url.username,
#     'NAME': mysql_url.path[1:],
#     'PASSWORD': mysql_url.password,
#     'OPTIONS': {
#         'ssl': {
#             'ca': SITE_ROOT + '/../cert/vosae/mysql_ca.pem',
#             'cert': SITE_ROOT + '/../cert/vosae/mysql_cert.pem',
#             'key': SITE_ROOT + '/../cert/vosae/mysql_id-key-no-password.pem'
#         },
#     }
# }


# Set your DSN value
SENTRY_DSN = os.getenv('SENTRY_DSN')

# Add raven to the list of installed apps
INSTALLED_APPS += (
    # ...
    'raven.contrib.django',
)

TEMPLATE_LOADERS = (
    ('django.template.loaders.cached.Loader', (
        'django.template.loaders.filesystem.Loader',
        'django.template.loaders.app_directories.Loader',
    )),
)


# Allowed hosts must be defined
ALLOWED_HOSTS = ("web.vosae.example.com",)


# Caches must be defined
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.dummy.DummyCache',
    },
    'staticfiles': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'staticfiles',
        'TIMEOUT': 60 * 60 * 24 * 365,
    }
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'root': {
        'level': 'WARNING',
        'handlers': ['sentry'],
    },
    'formatters': {
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(module)s %(process)d %(thread)d %(message)s'
        },
    },
    'handlers': {
        'sentry': {
            'level': 'ERROR',
            'class': 'raven.contrib.django.handlers.SentryHandler',
        },
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose'
        }
    },
    'loggers': {
        'django.db.backends': {
            'level': 'ERROR',
            'handlers': ['console'],
            'propagate': False,
        },
        'raven': {
            'level': 'DEBUG',
            'handlers': ['console'],
            'propagate': False,
        },
        'sentry.errors': {
            'level': 'DEBUG',
            'handlers': ['console'],
            'propagate': False,
        },
    },
}

# Static configuration
AWS_STATIC_BUCKET_NAME = ''  # Must be defined
STATIC_URL = os.getenv('STATIC_URL')
AWS_S3_CUSTOM_DOMAIN = os.getenv('STATIC_URL_DOMAIN')
STATICFILES_STORAGE = 'vosae_utils.S3CachedStorage'

# PUSHER
PUSHER_URL = urlparse.urlparse(os.getenv('PUSHER_URL'))
PUSHER_APP_ID = PUSHER_URL.path.split('/')[-1]
PUSHER_KEY = PUSHER_URL.username
PUSHER_SECRET = PUSHER_URL.password
PUSHER_HOST = PUSHER_URL.hostname
PUSHER_CLUSTER = 'eu'


# Import host conf here if needed
# try:
#     from .heroku import *
# except:
#     pass


# App endpoint must be defined
assert APP_ENDPOINT, u'VOSAE_APP_ENDPOINT is missing in environment'
