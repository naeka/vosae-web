# -*- coding:Utf-8 -*-

# Django settings for Vosae project.

import os


DEBUG = True
TRAVIS = False
TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

MANAGERS = ADMINS

SITE_ROOT = os.path.dirname(os.path.realpath(__file__ + '/../'))
APP_ENDPOINT = os.getenv('VOSAE_APP_ENDPOINT').rstrip('/') if os.getenv('VOSAE_APP_ENDPOINT') else None
SESSION_COOKIE_DOMAIN = os.getenv('VOSAE_COOKIE_DOMAIN')
CSRF_COOKIE_DOMAIN = os.getenv('VOSAE_COOKIE_DOMAIN')
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
SESSION_SERIALIZER = 'django.contrib.sessions.serializers.JSONSerializer'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.',  # Add 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': '',                      # Or path to database file if using sqlite3.
    }
}

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# On Unix systems, a value of None will cause Django to use the same
# timezone as the operating system.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'UTC'

# If you set this to True, Django will use timezone-aware datetimes.
USE_TZ = True

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en'

_ = lambda s: s
LANGUAGES = (
    ('en', _('English')),
    ('en-gb', _('British English')),
    ('fr', _('French')),
)

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True
LOCALE_PATHS = (
    os.path.join(SITE_ROOT, 'settings/locale'),
)

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale
USE_L10N = True

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
MEDIA_ROOT = os.path.join(SITE_ROOT, 'media')

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash if there is a path component (optional in other cases).
# Examples: "http://media.lawrence.com", "http://example.com/media/"
MEDIA_URL = '/media/'

STATIC_ROOT = os.path.join(SITE_ROOT, 'static').replace('\\', '/')
STATIC_URL = '/static/'

# URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
# trailing slash.
# Examples: "http://foo.com/media/", "/media/".
ADMIN_MEDIA_PREFIX = '/media/'

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
)


MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
)

ROOT_URLCONF = 'urls'

FONTS_DIR = os.path.join(SITE_ROOT, 'webapp/static/webapp/font')

STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.StaticFilesStorage'

STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
)

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.staticfiles',
    'templatetag_handlebars',
    'storages',
    'gunicorn',
    'statici18n',

    # Project specific
    'account',
    'webapp',
)

AUTHENTICATION_BACKENDS = (
    'account.backends.VosaeBackend',
)
AUTH_USER_MODEL = 'account.User'

TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.debug',
    'django.core.context_processors.i18n',
    'django.core.context_processors.media',
    'django.core.context_processors.static',
    'django.core.context_processors.request',
    'webapp.context_processors.vosae_settings',
    'webapp.context_processors.debug',
    'webapp.context_processors.travis',
    'webapp.context_processors.template_cache_timeout',
)

STATICI18N_PACKAGES = ('webapp',)
STATICI18N_ROOT = 'webapp/static/'
STATICI18N_OUTPUT_DIR = 'webapp/js/i18n'


# S3 Secret keys. If not is env use the development vars.
# NEVER USE DEVELOPMENT VARS IN PRODUCTION: AUTO DELETE AFTER 1 DAY.
AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = os.getenv('AWS_STORAGE_BUCKET_NAME')

AWS_QUERYSTRING_AUTH = False
DEFAULT_FILE_STORAGE = 'vosae_utils.VosaeS3BotoStorage'

SENTRY_DSN = None

TEMPLATE_CACHE_TIMEOUT = 60 * 60 * 24 * 7

# DO NOT PUT ANYTHING BELOW
