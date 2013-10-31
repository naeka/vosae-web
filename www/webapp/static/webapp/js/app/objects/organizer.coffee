Vosae.attendeeResponseStatutes = [
  Em.Object.create
    displayName: pgettext 'attendee response status', 'Unknown'
    fullDisplayName: pgettext 'attendee response status', 'Participation unknown'
    value: 'NEEDS-ACTION'
  Em.Object.create
    displayName: pgettext 'attendee response status', 'Declined'
    fullDisplayName: pgettext 'attendee response status', 'Participation declined'
    value: 'DECLINED'
  Em.Object.create
    displayName: pgettext 'attendee response status', 'Maybe'
    fullDisplayName: pgettext 'attendee response status', 'Participation uncertain'
    value: 'TENTATIVE'
  Em.Object.create
    displayName: pgettext 'attendee response status', 'Confirmed'
    fullDisplayName: pgettext 'attendee response status', 'Participation confirmed'
    value: 'ACCEPTED'
]

Vosae.reminderEntries = [
  Em.Object.create
    displayName: pgettext 'reminder entry', 'Notification'
    value: 'POPUP'
  Em.Object.create
    displayName: pgettext 'reminder entry', 'E-mail'
    value: 'EMAIL'
]

Vosae.calendarAclRuleRoles = [
  Em.Object.create
    displayName: pgettext 'calendar acl rule role', 'has no access'
    value: 'NONE'
  Em.Object.create
    displayName: pgettext 'calendar acl rule role', 'can see events'
    value: 'READER'
  Em.Object.create
    displayName: pgettext 'calendar acl rule role', 'can edit events'
    value: 'WRITER'
  Em.Object.create
    displayName: pgettext 'calendar acl rule role', 'is owner'
    value: 'OWNER'
]

Vosae.calendarListColors = [
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Green'
    value: '#dcf85f'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Fluorescent green'
    value: '#c7f784'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Blue'
    value: '#a3d7ea'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Orange'
    value: '#ffa761'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Red'
    value: '#eb5f3a'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Dark green'
    value: '#74a31e'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Dark blue'
    value: '#44b2ae'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Purple'
    value: '#7f54c0'
  Em.Object.create
    displayName: pgettext 'calendar list color', 'Dark purple'
    value: '#390a59'
]