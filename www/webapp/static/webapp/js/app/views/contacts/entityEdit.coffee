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
      url: "#{Vosae.Config.APP_ENDPOINT}/api/v1/file/"
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
        # Get the file record
        @get('controller.store').find("file", data.result['id']).then (file) =>
          @get('controller.content').setProperties
            photoSource: 'LOCAL'
            photo: file
            photoUri: file.get('streamLink')        
          Em.run.later @, (->
            @get('controller.content').set 'isUploading', false
          ), 1000

      error: =>
        @get('controller.content').set 'isUploading', false
        Vosae.ErrorPopup.open
          message: gettext 'An error occurred, please try again or contact the support'

      progress: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        @get("uploadProgressInstance").set "progress", progress

  uploadProgressBar: Vosae.RoundProgressBar.extend
    init: ->
      @_super()
      @get('parentView').set "uploadProgressInstance", @

  emailTypesField: Vosae.Select.extend()

  addressTypesField: Vosae.Select.extend()

  combinedPhoneTypesField: Vosae.Select.extend
    change: ->
      @get("phone").combinedTypeChanged @get("value")

  organizationSearchField: Vosae.OrganizationSearchSelect.extend
    allowClear: true

    onSelect: (event) ->
      @get("targetObject.store").find("organization", event.object.id).then (organization) =>
        @get('contact').set 'organization', organization

    onRemove: ->
      @get('contact').set 'organization', null

    updateFieldData: (->
      if @get("contact.organization")
        @get("contact.organization").then (organization) =>
          @.$().select2 'data',
            id: organization.get 'id'
            corporate_name: organization.get 'corporateName'
          @.$().select2 'val', organization.get('id')
    ).on "didInsertElement"
