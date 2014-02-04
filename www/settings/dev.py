# -*- coding:Utf-8 -*-

import os

from settings.base import *


# Used only in dev
SECRET_KEY = 'o4bpk#)!d5gxy7p9o5we6inz(yjqad=&o8p)n!3cr_k_csjl0i'

# Must use same SQLite database than app
# If no environment variable is set, consider vosae-app in the same directory than vosae-web
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.getenv('VOSAE_SQLITE_DATABASE', '../../vosae-app/www/vosae.sqlite3')
    }
}

CACHES = {
    'default': {
        "BACKEND": "redis_cache.cache.RedisCache",
        "LOCATION": "127.0.0.1:6379:0",
        "OPTIONS": {
            "CLIENT_CLASS": "redis_cache.client.DefaultClient",
            'PARSER_CLASS': 'redis.connection.HiredisParser',
        }
    }
}

try:
    from settings.local import *
except ImportError:
    pass
