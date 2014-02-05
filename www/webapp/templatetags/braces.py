# -*- coding:Utf-8 -*-

from django import template

register = template.Library()


class BracesNode(template.Node):

    """Wrap content in braces '{{' <content> '}}'"""

    def __init__(self, nodelist):
        self.nodelist = nodelist

    def render(self, context):
        return u'{{%s}}' % self.nodelist.render(context)


@register.tag
def braces(parser, token):
    nodelist = parser.parse(('endbraces',))
    parser.delete_first_token()
    return BracesNode(nodelist)
