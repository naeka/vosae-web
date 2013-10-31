###
  This component display an alert panel to the bottom
  of the window

  @class AlertPanel
  @namespace Vosae
  @module Components
###

Vosae.PopupComponent = Em.Component.extend Ember.DeferredMixin,
  defaultTemplate: Em.Handlebars.compile([
    '<div class="inner">'
      '<table>'
        '<tbody>'
          '<tr>'
            '<td class="component-popup-message">'
              '<p>{{view.message}}</p>'
            '</td>'
            '<td class="component-popup-buttons">'
              '{{#if view.secondary}}'
                '<button class="btn grey" rel="secondary">{{view.secondary}}</button>'
              '{{/if}}'
              '{{#if view.primary}}'
                '<button class="btn grey" rel="primary">{{view.primary}}</button>'
              '{{/if}}'
            '</td>'
          '</tr>'
        '</tboyd>'
      '</table>'
    '</div>'].join("\n"))
  classNames: 'component-popup'
  message: null
  primary: null
  secondary: null
  showBackdrop: false
  autoClose: false
  autoCloseAfter: 3500

  didInsertElement: ->
    @_setupFocusOnPrimaryButton()
    @_setupDocumentKeyHandler()
    @_setupAutoCloseTimeout() if @get('autoClose')

    # Display alert
    Em.run.later @, (->
      @_appendBackdrop() if @get('showBackdrop')
      @.$('.inner').addClass 'in'
    ), 200

  willDestroyElement: ->
    @_removeBackdrop() if @get('_backdrop')
    @_removeDocumentKeyHandler()

  keyPress: (event) ->
    if event.keyCode is 27
      unless @constructor is Vosae.ErrorPopupComponent
        @_triggerCallbackAndDestroy {close: true}, event

  click: (event) ->
    target = event.target
    targetRel = target.getAttribute("rel")
    if targetRel
      options = {}
      options[targetRel] = true
      @_triggerCallbackAndDestroy options, event
      false

  _setupFocusOnPrimaryButton: ->
    @.$("button.btn[rel='primary']").focus()

  _appendBackdrop: ->
    parentLayer = @.$().parent()
    $('#wrapper').addClass 'disabled'
    @_backdrop = jQuery('<div class="modal-backdrop"></div>').appendTo parentLayer

  _removeBackdrop: ->
    $('#wrapper').removeClass 'disabled'
    @_backdrop.remove()

  _setupAutoCloseTimeout: ->
    timeout = @get 'autoCloseAfter'
    @runLater = Em.run.later @, (->
      @_triggerCallbackAndDestroy {close: true}
    ), timeout

  _setupDocumentKeyHandler: ->
    handler = (event) => @keyPress event
  
    jQuery(window.document).bind 'keyup', handler
    @_keyUpHandler = handler

  _removeDocumentKeyHandler: ->
    jQuery(window.document).unbind 'keyup', @_keyUpHandler

  _resolveOrReject: (options, event) ->
    if options.primary
      @resolve options, event
    else
      @reject options, event

  _triggerCallbackAndDestroy: (options, event) ->
    Ember.run.cancel(@runLater) if @runLater
    @.$('.inner').removeClass 'in'
    if @callback
      destroy = @callback options, event
    if destroy is `undefined` or destroy
      Em.run.later @, (->
        @_resolveOrReject options, event
        @destroy()
      ), 300

Vosae.PopupComponent.reopenClass
  open: (options) ->
    if window.testMode
      return
    options = {} if !options
    popupComponent = @create options
    popupComponent.append()
    popupComponent

Vosae.ErrorPopupComponent = Vosae.PopupComponent.extend
  classNames: 'error'
  showBackdrop: true
  primary: gettext 'Ok'

Vosae.ConfirmPopupComponent = Vosae.PopupComponent.extend
  classNames: 'confirm'
  showBackdrop: true
  primary: gettext 'Yes'
  secondary: gettext 'No'

Vosae.SuccessPopupComponent = Vosae.PopupComponent.extend
  classNames: 'success'
  autoClose: true
  primary: gettext 'Ok'
