# Base model
Vosae.RegistrationInfo = DS.Model.extend
  businessEntity: DS.attr('string')
  shareCapital: DS.attr('string')

# Mixins
Vosae.EuRegistrationInfo = Ember.Mixin.create
  vatNumber: DS.attr('string')

# Localized
Vosae.BeRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'BE'

Vosae.ChRegistrationInfo = Vosae.RegistrationInfo.extend
  countryCode: 'CH'
  vatNumber: DS.attr('string')

Vosae.FrRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'FR'
  siret: DS.attr('string')
  rcsNumber: DS.attr('string')

Vosae.GbRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'GB'

Vosae.LuRegistrationInfo = Vosae.RegistrationInfo.extend Vosae.EuRegistrationInfo,
  countryCode: 'LU'

Vosae.UsRegistrationInfo = Vosae.RegistrationInfo.extend
  countryCode: 'US'


Vosae.RegistrationInfo.reopen
  registrationInfoFor: (countryCode)->
    switch countryCode
      when 'BE' then Vosae.BeRegistrationInfo
      when 'CH' then Vosae.ChRegistrationInfo
      when 'FR' then Vosae.FrRegistrationInfo
      when 'GB' then Vosae.GbRegistrationInfo
      when 'LU' then Vosae.LuRegistrationInfo
      when 'US' then Vosae.UsRegistrationInfo