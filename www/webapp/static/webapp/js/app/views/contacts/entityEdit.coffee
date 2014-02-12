Vosae.EntityEditView = Em.View.extend
  actions:
    openFileUploadBrowser: ->
      @.$().find('.fileupload').trigger('click')

  didInsertElement: ->
    @_super()

    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()

    # Initialize file upload zones
    @initAvatarUpload()

  initAvatarUpload: ->
    dropZone = @.$('section.main-infos')

    @.$('.fileupload').fileupload
      url: "#{APP_ENDPOINT}/api/v1/file/"
      dataType: 'json'
      formData:
        ttl: 60*24  # 1 day
        pipeline: JSON.stringify(
          [
            image: [
              {
                ratio: [1, 1]
              },
              {
                resize:
                  geometry: [256, 256]
                  constraint: "DONT_OVERSIZE"
              }
            ]
          ]
        )
      dropZone: dropZone
      pasteZone: dropZone
      paramName: 'uploaded_file'
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i

      drop: =>
        @get('controller.content').set 'isUploading', true

      done: (e, data) =>
        store = @get('controller.store')
        fileId = store.adapterForType(Vosae.File).get('serializer').deurlify data.result['resource_uri']
        data.result.id = fileId
        store.adapterForType(Vosae.File).load store, Vosae.File, data.result
        file = store.find Vosae.File, fileId
        @get('controller.content').setProperties
          photoSource: 'LOCAL'
          photo: file
          photoUri: file.get('streamLink')        
        Em.run.later @, (->
          @get('controller.content').set 'isUploading', false
        ), 1000

      error: =>
        @get('controller.content').set 'isUploading', false
        Vosae.ErrorPopupComponent.open
          message: gettext 'An error occurred, please try again or contact the support'

      progress: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        @get("uploadProgressInstance").set "progress", progress

  uploadProgressBar: Vosae.Components.RoundProgressBar.extend
    init: ->
      @_super()
      @get('parentView').set "uploadProgressInstance", @

  emailTypesField: Vosae.Components.Select.extend()

  addressTypesField: Vosae.Components.Select.extend()

  combinedPhoneTypesField: Vosae.Components.Select.extend
    change: ->
      @get("phone").combinedTypeChanged @get("value")

  organizationSearchField: Vosae.Components.OrganizationSearchField.extend
    allowClear: true

    onSelect: (event) ->
      organization = Vosae.Organization.find(event.object.id).then (organization) =>
        @get('contact').set 'organization', organization

    didInsertElement: ->
      @_super()
 
      organization = @get("contact.organization")
 
      if organization
        if organization.get('isLoaded')
          @.$().select2 'data',
            id: organization.get 'id'
            corporate_name: organization.get 'corporateName'
          @.$().select2 'val', organization.get('id')
        else
          organization.one "didLoad", @, ->
            @.$().select2 'data',
              id: organization.get 'id'
              corporate_name: organization.get 'corporateName'
            @.$().select2 'val', organization.get('id')
