Vosae.EntityController = Em.ObjectController.extend
  actions:
    getExportFile: ->
      format = "vcard"
      tenantSlug = @get('session.tenant.slug')
      entity_id = @get('content.id')
      exportURL = "#{APP_ENDPOINT}#{@get('store').adapter.namespace}/"
      
      switch @constructor.toString()
        when Vosae.ContactShowController.toString()
          exportURL += "contact/"
        when Vosae.OrganizationShowController.toString()
          exportURL += "organization/"
      
      exportURL += "#{entity_id}/export/#{format}/?x_vc=#{tenantSlug}"

      $.fileDownload(exportURL)

    addAddress: ->
      @get('addresses').createRecord()
      Em.run.later @, (->
        $('table.addresses tr:not(.add) .ember-text-field.address').focus()
      ), 200

    addPhone: ->
      @get('phones').createRecord()
      Em.run.later @, (->
        $('table.phones tr:not(.add) .ember-text-field').focus()
      ), 200

    addEmail: ->
      @get('emails').createRecord()
      Em.run.later @, (->
        $('table.emails tr:not(.add) .ember-text-field').focus()
      ), 200

    deletePhone: (phone) ->
      Vosae.ConfirmPopupComponent.open
        message: gettext 'Do you really want to delete this phone?'
        callback: (opts, event) =>
          if opts.primary
           @get('phones').removeObject phone      

    deleteEmail: (email) ->
      Vosae.ConfirmPopupComponent.open
        message: gettext 'Do you really want to delete this email?'
        callback: (opts, event) =>
          if opts.primary
           @get('emails').removeObject email

    deleteAddress: (address) ->
      Vosae.ConfirmPopupComponent.open
        message: gettext 'Do you really want to delete this address?'
        callback: (opts, event) =>
          if opts.primary
           @get('addresses').removeObject address

    cancel: (entity) ->
      switch entity.constructor.toString()
        when Vosae.Contact.toString()
          if entity.get('id')
            return @transitionToRoute 'contact.show', @get('session.tenant'), entity
          else
            return @transitionToRoute 'contacts.show', @get('session.tenant')
        when Vosae.Organization.toString()
          if entity.get('id')
            return @transitionToRoute 'organization.show', @get('session.tenant'), entity
          else
            return @transitionToRoute 'organizations.show', @get('session.tenant')
      return

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
        event = if entity.get('id') then 'didUpdate' else 'didCreate'
        entity.one event, @, ->
          Ember.run.next @, ->
            switch entity.constructor.toString()
              when Vosae.Contact.toString()
                Vosae.metaForContact.incrementProperty('total_count')
                @transitionToRoute 'contact.show', @get('session.tenant'), entity
              when Vosae.Organization.toString()
                Vosae.metaForOrganization.incrementProperty('total_count')
                @transitionToRoute 'organization.show', @get('session.tenant'), entity

        entity.get('transaction').commit()

    delete: (entity) ->
      message = switch entity.constructor.toString()
        when Vosae.Contact.toString()
          gettext 'Do you really want to delete this contact?'
        when Vosae.Organization.toString()
          gettext 'Do you really want to delete this organization?'

      Vosae.ConfirmPopupComponent.open
        message: message
        callback: (opts, event) =>
          if opts.primary
            entity.one 'didDelete', @, ->
              Ember.run.next @, ->
                switch entity.constructor.toString()
                  when Vosae.Contact.toString()
                    Vosae.metaForContact.decrementProperty('total_count')
                    @transitionToRoute 'contacts.show', @get('session.tenant')
                  when Vosae.Organization.toString()
                    Vosae.metaForOrganization.decrementProperty('total_count')
                    @transitionToRoute 'organizations.show', @get('session.tenant')
            entity.deleteRecord()
            entity.get('transaction').commit()