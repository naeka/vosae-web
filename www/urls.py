# -*- coding:Utf-8 -*-

from django.conf import settings
from django.conf.urls import patterns, url, include
from django.conf.urls.i18n import i18n_patterns
from django.contrib.staticfiles.urls import staticfiles_urlpatterns


urlpatterns = patterns('')

if settings.DEBUG:
    urlpatterns += staticfiles_urlpatterns()
    urlpatterns += patterns(
        'webapp.views',
        url(r'^spec/$', 'spec', name="spec"),
        url(r'^test-css/$', 'test_css', name="test-css")
    )

urlpatterns += patterns(
    'webapp.views',
    url(r'^', 'webapp', name="webapp"),
)

# Never enters here (every request is caught by webapp view).
# Only used for translations to properly redirect on app
urlpatterns += i18n_patterns(
    '',
    (r'', include('account.urls', app_name='account')),
)
