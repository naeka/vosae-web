###
  Serializer for model `Vosae.User`.

  @class UserSerializer
  @extends Vosae.ApplicationSerializer
  @namespace Vosae
  @module Vosae
###

Vosae.UserSerializer = Vosae.ApplicationSerializer.extend
  attrs:
    specificPermissions:
      embedded: 'always'
    settings:
      embedded: 'always'