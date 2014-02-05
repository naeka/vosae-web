# -*- coding:Utf-8 -*-

from django.conf import settings
from django.shortcuts import render_to_response
from django.core.urlresolvers import reverse
from django.template import RequestContext
from django.http import HttpResponseRedirect


def webapp(request):
    if not request.user.is_authenticated():
        return HttpResponseRedirect(settings.APP_ENDPOINT)
    if not request.user.has_usable_password():
        return HttpResponseRedirect(settings.APP_ENDPOINT + reverse('initial_password_setup'))
    if not request.user.has_identity_set():
        return HttpResponseRedirect(settings.APP_ENDPOINT + reverse('set_identity'))

    if not settings.DEBUG:
        handlebars_path = 'webapp/build/templates.{0}.min.js'.format(request.LANGUAGE_CODE)
    else:
        handlebars_path = None

    return render_to_response('webapp/skeleton.html', {'handlebars_path': handlebars_path}, context_instance=RequestContext(request))


def spec(request):
    # During specs tests we use local static files (even during Travis builds)
    original_settings_staticfiles_storage = settings.STATICFILES_STORAGE
    settings.STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.StaticFilesStorage'

    # Force the auth user email during specs
    request.user.email = "spec@vosae.com"

    response = render_to_response("webapp/spec.html", context_instance=RequestContext(request))
    settings.STATICFILES_STORAGE = original_settings_staticfiles_storage
    return response

def test_css(request):
    return render_to_response('webapp/test-css.html', context_instance=RequestContext(request))
