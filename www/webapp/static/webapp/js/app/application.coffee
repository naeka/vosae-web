unless window.VosaeApplication
  
  window.VosaeApplication = Em.Application.extend
    preWindowLocation: null
    tenantsAreLoaded: false
    currenciesAreLoaded: false

    # Lookup into the application to find instance of controller or store
    lookup: (path) ->
      @__container__.lookup(path)

    # Application runner
    run: ->
      @injectDependencies()
      @configI18n()
      @configPlugins()
      @createMetaControllers()
      @getTenants()
      @getCurrencies()

    # Inject dependencies to app components
    injectDependencies: ->
      # Inject session object into views, routes and controllers
      this.register 'session:current', Vosae.Session, {singleton: true}
      this.inject 'view', 'session', 'session:current'
      this.inject 'route', 'session', 'session:current'
      this.inject 'controller', 'session', 'session:current'

    # Configure the i18n according to the user language
    configI18n: ->
      Vosae.currentLanguage = LANGUAGE
      moment.lang Vosae.currentLanguage

    # Meta controllers for models, should be moved elsewhere
    createMetaControllers: ->
      @set 'metaForContact' , Em.Object.createWithMixins Vosae.MetaController
      @set 'metaForOrganization' , Em.Object.createWithMixins Vosae.MetaController
      @set 'metaForQuotation' , Em.Object.createWithMixins Vosae.MetaController
      @set 'metaForInvoice' , Em.Object.createWithMixins Vosae.MetaController
      @set 'metaForItem' , Em.Object.createWithMixins Vosae.MetaController
      @set 'metaForTimeline' , Em.Object.createWithMixins Vosae.MetaController
      @set 'metaForNotification' , Em.Object.createWithMixins Vosae.MetaController      
      @set 'metaForCurrency' , Em.Object.createWithMixins Vosae.MetaController      
      @set 'metaForTenant' , Em.Object.createWithMixins Vosae.MetaController

    configPlugins: ->
      # jQuery file upload
      $.widget 'blueimp.fileupload', $.blueimp.fileupload,
        options:
          messages:
            acceptFileTypes: gettext("File type not allowed")
            maxFileSize: gettext("This file is too large")
            maxNumberOfFiles: gettext("The maximum number of files exceeded")
            minFileSize: gettext("This file is too small")
            uploadedBytes: gettext("Uploaded datas exceed file size")
          maxFileSize: 2000000
          minFileSize: 500
          maxNumberOfFiles: 1
          processfail: (e, data) =>
            if data.files[data.index].error
              alert(data.files[data.index].name + ' : ' + data.files[data.index].error)

    # Check that tenants and currencies have been fetched and loaded
    checkDataDependencies: ->
      depenciesAreLoaded = true
      depencies = ['tenantsAreLoaded', 'currenciesAreLoaded']

      depencies.forEach (dep) =>
        unless @get(dep)
          depenciesAreLoaded = false
      if depenciesAreLoaded
        @advanceReadiness()

    # Fetch all tenants related to the current user
    getTenants: ->
      offset = @metaForTenant.getNextOffset()
      tenants = Vosae.Tenant.find(offset: offset)
      tenants.one "didLoad", @, ->
        if Vosae.metaForTenant.next
          @getTenants()
        else
          @set "tenantsAreLoaded", true
          @checkDataDependencies()
    
    # Fetch all currencies
    getCurrencies: ->
      offset = @metaForCurrency.getNextOffset()
      currencies = Vosae.Currency.find(offset: offset)
      currencies.one "didLoad", @, ->
        if Vosae.metaForCurrency.next
          @getCurrencies()
        else
          @set 'currenciesAreLoaded', true
          @checkDataDependencies()

    # Display app laoder
    showLoader: ->
      $("#wrapper-loader").fadeIn()

    # Hide app laoder
    hideLoader: ->
      $("#wrapper-loader").fadeOut()

    # Set new title to page
    setPageTitle: (title) ->
      $(document).attr 'title', "#{title} - Vosae"