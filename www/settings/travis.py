# -*- coding:Utf-8 -*-

from settings.base import *


DEBUG = True
TRAVIS = True


# Used only in dev
SECRET_KEY = 'o4bpk#)!d5gxy7p9o5we6inz(yjqad=&o8p)n!3cr_k_csjl0i'

APP_ENDPOINT = 'http://localhost:8000'

# Set your DSN value
SENTRY_DSN = os.getenv('SENTRY_DSN')

# Add raven to the list of installed apps
INSTALLED_APPS += (
    # ...
    'raven.contrib.django',
)


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
