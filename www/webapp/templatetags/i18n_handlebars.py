from django import template
from django.utils import translation

from templatetag_handlebars.templatetags.templatetag_handlebars import verbatim_tags


register = template.Library()


class VerbatimTransNode(template.Node):

    """Keeps intact and translates a block"""

    def __init__(self, text_and_nodes):
        self.text_and_nodes = text_and_nodes

    def render(self, context):
        output = ""
        # If its text we concatenate it, otherwise it's a node and we render it
        for bit in self.text_and_nodes:
            if isinstance(bit, basestring):
                output += bit
            else:
                output += bit.render(context)
        return translation.ugettext(output)


@register.tag
def verbatimblocktrans(parser, token):
    text_and_nodes = verbatim_tags(parser, token, endtagname='endverbatimblocktrans')
    return VerbatimTransNode(text_and_nodes)
