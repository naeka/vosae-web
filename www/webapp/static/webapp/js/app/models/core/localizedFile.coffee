###
  A data model that represents a localized file

  @class LocalizedFile
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.LocalizedFile = Vosae.Model.extend
  'fr': DS.belongsTo("file")
  'en': DS.belongsTo("file")
  'en-gb': DS.belongsTo("file")