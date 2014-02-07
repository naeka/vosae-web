Vosae.DataLiberation = DS.Model.extend
  createdAt: DS.attr("date")
  language: DS.attr("string")
  documentsTypes: DS.attr("string")
  fromDate: DS.attr("date")
  toDate: DS.attr("date")
  issuer: DS.belongsTo("Vosae.User")
  zipfile: DS.belongsTo("Vosae.File")