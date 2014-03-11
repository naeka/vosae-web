# Vosae.AddressSerializer = Vosae.ApplicationSerializer.extend
#   normalize: (type, hash, prop) ->
#     delete hash.type
#     delete hash.label
#     delete hash.geo_point
#     return @_super type, hash, prop