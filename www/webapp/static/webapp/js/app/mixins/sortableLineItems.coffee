###
  This mixin allow user to sort his line items position with a drag & drop.

  @class SortableLineItemsMixin
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.SortableLineItemsMixin = Ember.Mixin.create
  sortableLineItemsSelector: ".table-line-items tbody"
  sortableLineItemsPlaceholder: "ui-sortable-placeholder"
  sortableLineItemsHandle: ".handle"

  initSortable: (->
    # Init sortable widget on table
    $(@sortableLineItemsSelector).sortable
      handle: @sortableLineItemsHandle
      placeholder: @sortableLineItemsPlaceholder
      stop: (event, ui) =>
        index = $("tr").index(ui.item[0]) - 1
        guid = $(ui.item[0]).attr('guid')
        @moveLineItemToIndex guid, index
  ).on "didInsertElement"

  refreshSortableWidget: (->
    # Refresh widget if a `LineItem` has been added or removed
    Em.run.later @, ->
      if $(@sortableLineItemsSelector).hasClass "ui-sortable"
        $(@sortableLineItemsSelector).sortable "refresh"
    , 200
  ).observes('controller.currentRevision.lineItems.length')

  moveLineItemToIndex: (guid, toIndex) ->
    fromIndex = null
    lineItems = @get 'controller.currentRevision.lineItems'

    # Find the `LineItem` according to he guid
    lineItems.find (item, index) ->
      if Em.guidFor(item) == guid
        fromIndex = index
        return true

    # Change his index
    if fromIndex? and toIndex?
      lineItems.content.splice toIndex, 0, lineItems.content.splice(fromIndex, 1)[0]

    # Set the `InvoiceBase` as dirty
    @get('controller.content').becameDirty()

  destroySortable: (->
    # Disabled sortable widget on table
    $(@sortableLineItemsSelector).sortable("destroy")
  ).on "willDestroyElement"
