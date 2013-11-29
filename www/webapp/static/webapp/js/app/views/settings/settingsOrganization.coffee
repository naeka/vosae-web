Vosae.SettingsOrganizationView = Vosae.PageSettingsView.extend
  classNames: ["outlet-settings"]

  didInsertElement: ->
    @_super()
    @initLogoUpload()
    @initTermsUpload()

  # Actions handlers
  actions:
    openLogoUploadBrowser: ->
      @.$(".logo .fileupload").click()

    openTermsUploadBrowser: ->
      @.$(".terms .fileupload").click()

  initLogoUpload: ->
    @.$('.logo .fileupload').fileupload
      url: "#{APP_ENDPOINT}/api/v1/file/"
      dataType: 'json'
      formData:
        ttl: 60*24  # 1 day
      dropZone: @.$('.logo .dropzone')
      pasteZone: @.$('.logo .dropzone')
      paramName: 'uploaded_file'
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
      maxFileSize: 2000000
      minFileSize: 500
      maxNumberOfFiles: 1
      start: =>
        @get('controller.content').set 'isUploadingLogo', true
      always: =>
        @get('controller.content').set 'isUploadingLogo', false
      done: (e, data) =>
        store = @get('controller.store')
        fileId = store.adapterForType(Vosae.File).get('serializer').deurlify data.result['resource_uri']
        data.result.id = fileId
        store.adapterForType(Vosae.File).load store, Vosae.File, data.result
        file = store.find Vosae.File, fileId
        if file.get('name').match /\.(svg|ps|eps)$/i
          @get('controller.content').set 'svgLogo', file
        else
          @get('controller.content').set 'imgLogo', file
      progress: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        @.$('.logo .progress .bar').css "width", "#{progress}%"
        @.$('.logo .progress-text').html "#{progress}%"

  initTermsUpload: ->
    @.$('.terms .fileupload').fileupload
      url: "#{APP_ENDPOINT}/api/v1/file/"
      dataType: 'json'
      formData:
        ttl: 60*24  # 1 day
      dropZone: @.$('.terms')
      pasteZone: @.$('.terms')
      paramName: 'uploaded_file'
      acceptFileTypes: /(\.|\/)(pdf|ps|doc|docx|rtf|txt)$/i
      maxFileSize: 2000000
      minFileSize: 500
      maxNumberOfFiles: 1
      start: =>
        @get('controller.content').set 'isUploadingTerms', true
      always: =>
        @get('controller.content').set 'isUploadingTerms', false
      done: (e, data) =>
        store = @get('controller.store')
        fileId = store.adapterForType(Vosae.File).get('serializer').deurlify data.result['resource_uri']
        data.result.id = fileId
        store.adapterForType(Vosae.File).load store, Vosae.File, data.result
        file = store.find Vosae.File, fileId
        @get('controller.content').set 'terms', file
      progress: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        @.$('.terms .progress .bar').css "width", "#{progress}%"
        @.$('.terms .progress-text').html "#{progress}%"

  registrationInfoView: Ember.ContainerView.extend
    childViews: ['registrationCountryType']

    registrationCountryType: Em.View.extend
      templateName: "settings/organization/registrationCountryType"
      tagName: "tbody"
      select: Vosae.Components.Select.extend
        init: ->
          @_super()
          countryCode = @get('tenant.registrationInfo.countryCode')
          @set('value', countryCode)

        didInsertElement: ->
          @_super()
          countryCode = @get('tenant.registrationInfo.countryCode')
          parentView = @get('parentView.parentView')
          registrationCountryForm = parentView.createChildView Ember.View,
            tagName: "tbody"
            templateName: "settings/partials/registrationInfo/#{countryCode}"
          parentView.pushObject registrationCountryForm

        change: ->
          countryCode = @get('value')
          # Change registration info country. Keeps common informations
          oldRegistrationInfo = @get('tenant.registrationInfo')
          newRegistrationInfo = oldRegistrationInfo.registrationInfoFor(countryCode).createRecord
            businessEntity: oldRegistrationInfo.get('businessEntity')
            shareCapital: oldRegistrationInfo.get('shareCapital')
          @set('tenant.registrationInfo', newRegistrationInfo)
          parentView = @get('parentView.parentView')
          registrationCountryForm = parentView.get('childViews')[1]
          registrationCountryForm.set('templateName', "settings/partials/registrationInfo/#{countryCode}")
          registrationCountryForm.rerender()