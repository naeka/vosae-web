###
  A custom object controller for a `Vosae.Entity` based record.

  @class EntityController
  @extends Ember.ObjectController
  @namespace Vosae
  @module Vosae
###

Vosae.EntityController = Ember.ObjectController.extend
  exportFormat: "vcard"
  relatedType: null

  checkRelatedType: (->
    Ember.Logger.error(@toString() + " needs the property `relatedType` to be defined.") if Em.isNone @relatedType
  ).on "init"

  ###
    Build the URL that will be used by the library `fileDownload`
  ###
  getExportURL: ->
    tenantSlug = @get "session.tenant.slug"
    entityID = @get "content.id"
    url = "#{Vosae.Config.APP_ENDPOINT}/#{Vosae.Config.API_NAMESPACE}/"      
    url + "#{@relatedType}/#{entityID}/export/#{@exportFormat}/?x_tenant=#{tenantSlug}"

  actions:
    ###
      Generate an ajax download with the url from @getExportURL
    ###
    getExportFile: ->
      $.fileDownload @getExportURL()
    
    addAddress: ->
      @get('addresses').then (addresses) ->
        addresses.createRecord()
        Em.run.later @, (->
          $('table.addresses tr:not(.add) .ember-text-field.address').focus()
        ), 200

    addPhone: ->
      @get('phones').then (phones) ->
        phones.createRecord()
        Em.run.later @, (->
          $('table.phones tr:not(.add) .ember-text-field').focus()
        ), 200

    addEmail: ->
      @get('emails').then (emails) ->
        emails.createRecord()
        Em.run.later @, (->
          $('table.emails tr:not(.add) .ember-text-field').focus()
        ), 200

    deletePhone: (phone) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this phone?'
        callback: (opts, event) =>
          if opts.primary
            @get('phones').removeObject phone      

    deleteEmail: (email) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this email?'
        callback: (opts, event) =>
          if opts.primary
            @get('emails').removeObject email

    deleteAddress: (address) ->
      Vosae.ConfirmPopup.open
        message: gettext 'Do you really want to delete this address?'
        callback: (opts, event) =>
          if opts.primary
            @get('addresses').removeObject address

    cancel: (entity) ->
      switch
        when entity instanceof Vosae.Contact
          if entity.get('id')
            @transitionToRoute 'contact.show', @get('session.tenant'), entity
          else
            @transitionToRoute 'contacts.show', @get('session.tenant')
        when entity instanceof Vosae.Organization
          if entity.get('id')
            @transitionToRoute 'organization.show', @get('session.tenant'), entity
          else
            @transitionToRoute 'organizations.show', @get('session.tenant')

    save: (entity) ->
      errors = []

      # Validate entity
      errors = errors.concat entity.getErrors()
      
      # Validate addresses
      entity.get('addresses').forEach (address) ->
        errors = errors.concat address.getErrors()

      # Validate phones
      entity.get('phones').forEach (phone) ->
        errors = errors.concat phone.getErrors()

      # Validate emails
      entity.get('emails').forEach (email) ->
        errors = errors.concat email.getErrors()

      if errors.length
        alert(errors.join('\n'))
      else
        entity.save().then (entity) =>
          switch
            when entity instanceof Vosae.Contact
              @store.metadataFor("contact").incrementProperty('totalCount')
              @transitionToRoute 'contact.show', @get('session.tenant'), entity
            when entity instanceof Vosae.Organization
              @store.metadataFor("organization").incrementProperty('totalCount')
              @transitionToRoute 'organization.show', @get('session.tenant'), entity

    delete: (entity) ->
      message = switch
        when entity instanceof Vosae.Contact
          gettext 'Do you really want to delete this contact?'
        when entity instanceof Vosae.Organization
          gettext 'Do you really want to delete this organization?'

      Vosae.ConfirmPopup.open
        message: message
        callback: (opts, event) =>
          if opts.primary
            entity.deleteRecord()
            entity.save().then =>
              switch
                when entity instanceof Vosae.Contact
                  @store.metadataFor("contact").decrementProperty('totalCount')
                  @transitionToRoute 'organizations.show', @get('session.tenant')
                when entity instanceof Vosae.Organization
                  @store.metadataFor("organization").decrementProperty('totalCount')
                  @transitionToRoute 'organizations.show', @get('session.tenant')
