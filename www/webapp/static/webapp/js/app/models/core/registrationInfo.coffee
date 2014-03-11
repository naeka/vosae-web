###
  A base model that represents registration informations for all countries

  @class RegistrationInfo
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.RegistrationInfo = Vosae.Model.extend
  businessEntity: DS.attr('string')
  shareCapital: DS.attr('string')

Vosae.RegistrationInfo.reopen
  tenant: DS.belongsTo('tenant')

  registrationInfoFor: (countryCode) ->
    switch countryCode
      when 'BE' then Vosae.BeRegistrationInfo
      when 'CH' then Vosae.ChRegistrationInfo
      when 'FR' then Vosae.FrRegistrationInfo
      when 'GB' then Vosae.GbRegistrationInfo
      when 'LU' then Vosae.LuRegistrationInfo
      when 'US' then Vosae.UsRegistrationInfo


###
  A mixin for registration informations of europeen countries

  @class EuRegistrationInfo
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.EuRegistrationInfo = Ember.Mixin.create
  vatNumber: DS.attr('string')


###
  A data model that represents registration informations for Belgium

  @class BeRegistrationInfo
  @extends Vosae.RegistrationInfo
  @uses Vosae.EuRegistrationInfo
  @namespace Vosae
  @module Vosae
###

Vosae.BeRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'BE'


###
  A data model that represents registration informations for Swiss

  @class ChRegistrationInfo
  @extends Vosae.RegistrationInfo
  @namespace Vosae
  @module Vosae
###

Vosae.ChRegistrationInfo = Vosae.RegistrationInfo.extend
  countryCode: 'CH'
  vatNumber: DS.attr('string')


###
  A data model that represents registration informations for France

  @class FrRegistrationInfo
  @extends Vosae.RegistrationInfo
  @uses Vosae.EuRegistrationInfo
  @namespace Vosae
  @module Vosae
###

Vosae.FrRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'FR'
  siret: DS.attr('string')
  rcsNumber: DS.attr('string')


###
  A data model that represents registration informations for Grand Britain

  @class GbRegistrationInfo
  @extends Vosae.RegistrationInfo
  @uses Vosae.EuRegistrationInfo
  @namespace Vosae
  @module Vosae
###

Vosae.GbRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'GB'


###
  A data model that represents registration informations for Luxembourg

  @class LuRegistrationInfo
  @extends Vosae.RegistrationInfo
  @uses Vosae.EuRegistrationInfo
  @namespace Vosae
  @module Vosae
###

Vosae.LuRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'LU'


###
  A data model that represents registration informations for United States

  @class UsRegistrationInfo
  @extends Vosae.RegistrationInfo
  @namespace Vosae
  @module Vosae
###

Vosae.UsRegistrationInfo = Vosae.RegistrationInfo.extend
  countryCode: 'US'