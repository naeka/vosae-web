Vosae.VosaeCalendar = DS.Model.extend
  summary: DS.attr('string')
  description: DS.attr('string')
  location: DS.attr('string')
  timezone: DS.attr('string')
  acl: DS.belongsTo('Vosae.CalendarAcl')

Vosae.Adapter.map "Vosae.VosaeCalendar",
  acl:
    embedded: "always"