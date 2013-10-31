# -*- coding:Utf-8 -*-

from django.conf.urls import patterns, url
from django.utils.translation import ugettext_lazy as _


# Never enters here (every request is caught by webapp view).
# Only used for translations to properly redirect on app
urlpatterns = patterns(
    '',
    url(_(r'^account/signin/$'), 'signin', name="signin"),
    url(_(r'^account/signout/$'), 'signout', name="signout"),
    url(_(r'^account/identity/set/$'), 'set_identity', name='set_identity'),
    url(_(r'^account/password/set/$'), 'initial_password_setup', name='initial_password_setup'),
)
