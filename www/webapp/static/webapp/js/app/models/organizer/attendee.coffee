Vosae.Attendee = DS.Model.extend
  email: DS.attr('string')
  displayName: DS.attr('string')
  organizer: DS.attr('boolean')
  vosaeUser: DS.belongsTo('Vosae.User')
  photoUri: DS.attr('string')
  optional: DS.attr('boolean')
  responseStatus: DS.attr('string')
  comment: DS.attr('string')
