# -*- coding:Utf-8 -*-

from django.conf import settings


def vosae_settings(context):
    return {
        'SENTRY_DSN': settings.SENTRY_DSN,
        'PUSHER_KEY': getattr(settings, 'PUSHER_KEY', None),
        'PUSHER_CLUSTER': getattr(settings, 'PUSHER_CLUSTER', None),
        'APP_ENDPOINT': settings.APP_ENDPOINT
    }


def debug(context):
    return {'DEBUG': settings.DEBUG}


def travis(context):
    return {'TRAVIS': settings.TRAVIS}
