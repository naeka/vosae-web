###
  A data model that represents a localized file

  @class LocalizedFile
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.LocalizedFile = Vosae.Model.extend
  'fr': DS.belongsTo("Vosae.File")
  'en': DS.belongsTo("Vosae.File")
  'en-gb': DS.belongsTo("Vosae.File")