# -*- coding:Utf-8 -*-

from django.core.management.base import BaseCommand
from django.template import Context, Template
from django.conf import settings
import datetime
import pytz
import os


class Command(BaseCommand):
    help = 'Generate timezones for web client (coffeescript).'

    def handle(self, *args, **options):
        # tuple(tzname, utc_offset, display_name)
        tz_list = []
        normal = datetime.datetime(2013, 1, 1)
        tzinfo_template = Template("""\n  Em.Object.create\n    value: \"{{ tzname }}\"\n    utcOffset: {{ utc_offset }}\n    displayName: \"{{ display_name }}\"""")

        for tzname in pytz.common_timezones:
            tz = pytz.timezone(tzname)
            try:
                kwargs = {}
                if tz is not pytz.utc:
                    # All timezones minus UTC should set is_dst
                    kwargs.update(is_dst=True)
                utc_offset = tz.utcoffset(normal, **kwargs)
            except:
                continue
            offset = utc_offset.seconds if utc_offset.days == 0 else utc_offset.days * 86400 + utc_offset.seconds
            sign = '-' if offset < 0 else '+'
            display_name = '(GMT{0}{1:02d}:{2:02d}) {3}'.format(sign, abs(offset) / 3600, abs(offset) % 3600 / 60, tz.zone.split('/')[-1].replace('_', ' '))
            tz_list.append((tzname, offset, display_name))

        tz_list = sorted(tz_list, key=lambda tzinfo: tzinfo[1])

        buf = u"Vosae.timezones = ["
        for tzinfo in tz_list:
            buf += tzinfo_template.render(Context({
                'tzname': tzinfo[0],
                'utc_offset': tzinfo[1],
                'display_name': tzinfo[2]
            }))

        buf += "\n]\n"

        outfile = open(os.path.join(settings.SITE_ROOT, 'webapp/static/webapp/js/app/objects/timezones.coffee'), 'w')
        outfile.write(buf)
        outfile.close()
        print 'Successfully generated file "webapp/static/webapp/js/app/objects/timezones.coffee"'
