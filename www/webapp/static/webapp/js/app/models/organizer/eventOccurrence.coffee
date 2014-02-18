###
  A data model that represents an event occurrence

  @class EventOccurrence
  @extends Vosae.Model
  @namespace Vosae
  @module Vosae
###

Vosae.EventOccurrence = Vosae.Model.extend
  id: DS.attr('string')
  start: DS.attr('datetime')
  end: DS.attr('datetime')
