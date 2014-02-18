###
  A data model that represents user settings

  @class UserSettings
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.UserSettings = Vosae.Model.extend
  languageCode: DS.attr('string')
  emailSignature: DS.attr('string')
  gravatarEmail: DS.attr('string')

