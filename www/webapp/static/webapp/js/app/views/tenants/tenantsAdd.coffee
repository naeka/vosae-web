Vosae.TenantsAddView = Vosae.PageTenantView.extend
  classNames: ["outlet-tenants", "page-add-tenant"]
  
  inStepIdentity: true
  inStepCoords: false
  inStepRegistration: false
  formIsValid: true
  registrationCountry: null

  didInsertElement: ->
    @_super()
    @get('controller').set 'supportedCurrencies', []
    @get('controller').set 'defaultCurrency', null
    # Focus on first input text
    @.$().find('.ember-text-field').first().focus()
    Vosae.hideLoader()

  # Action handlers
  actions:
    # Go to form previous step
    previousStep: (tenant) ->
      currentStep = @getCurrentStep()
      switch currentStep
        when 'stepCoords'
          @setProperties
            inStepIdentity: true
            inStepCoords: false
            inStepRegistration: false
        when 'stepRegistration'
          @setProperties
            inStepIdentity: false
            inStepCoords: true
            inStepRegistration: false
      @set 'formIsValid', true
      $("#ct-tenant").scrollTop(0)

    # Go to form next step
    nextStep: (tenant) ->
      tenant.resetErrors()
      currentStep = @getCurrentStep()
      switch currentStep
        when 'stepIdentity'
          if @stepIdentityIsValid tenant
            @setProperties
              inStepIdentity: false
              inStepCoords: true
              inStepRegistration: false
          $("#ct-tenant").scrollTop(0)
        when 'stepCoords'
          if @stepCoordsIsValid tenant
            @setProperties
              inStepIdentity: false
              inStepCoords: false
              inStepRegistration: true
          $("#ct-tenant").scrollTop(0)
        when 'stepRegistration'
          if @stepRegistrationIsValid tenant
            @get('controller').send "save", tenant
          else
            $("#ct-tenant").scrollTop(0)
      # Focus on first input text
      @.$().find('.ember-text-field').first().focus()

  # Returns form's current step
  getCurrentStep: ->
    if @inStepIdentity
      return 'stepIdentity'
    if @inStepCoords
      return 'stepCoords'
    if @inStepRegistration
      return 'stepRegistration'
    return undefined

  # Check if form step identity is valid
  stepIdentityIsValid: (tenant) ->
    isValid = true
    fields = [
      'name', 
      'email'
    ]

    for field in fields
      if !tenant.get(field)
        @setFieldAsRequired tenant, field
        isValid = false

    @set 'formIsValid', isValid
    return isValid

  # Check if form step coords is valid
  stepCoordsIsValid: (tenant) ->
    isValid = true
    fields = [
      'postalAddress.streetAddress',
      'postalAddress.city',
      'postalAddress.country',
      'billingAddress.streetAddress',
      'billingAddress.city',
      'billingAddress.country'
    ]

    for field in fields
      if !tenant.get(field)
        @setFieldAsRequired tenant, field
        isValid = false

    @set 'formIsValid', isValid
    return isValid

  # Check if form step registration is valid
  stepRegistrationIsValid: (tenant) ->
    isValid = true
    
    # Supported currencies
    if Ember.isEmpty @get('controller.supportedCurrencies')
      isValid = false
      @setFieldAsRequired 'id_tenant_supported_currencies'
    
    # Default currencies
    if Ember.isEmpty @get('controller.defaultCurrency')
      isValid = false
      @setFieldAsRequired 'id_tenant_default_currency'
    
    # Registration info share capital
    if not tenant.get 'registrationInfo.shareCapital'
      isValid = false
      @setFieldAsRequired 'id_tenant_registration_share_capital'    
    
    # Registration info
    switch tenant.get 'registrationInfo.countryCode'
      # France
      when 'FR'
        if not tenant.get 'registrationInfo.vatNumber'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_vat_number'
        if not tenant.get 'registrationInfo.siret'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_siret'
        if not tenant.get 'registrationInfo.rcsNumber'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_rcs_number'
      # Belgium
      when 'BE'
        if not tenant.get 'registrationInfo.vatNumber'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_vat_number'
      # Switzerland
      when 'CH'
        if not tenant.get 'registrationInfo.vatNumber'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_vat_number'
      # Great Britain
      when 'GB'
        if not tenant.get 'registrationInfo.vatNumber'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_vat_number'
      # Luxembourg
      when 'LU'
        if not tenant.get 'registrationInfo.vatNumber'
          isValid = false
          @setFieldAsRequired 'id_tenant_registration_vat_number'

    @set 'formIsValid', isValid
    return isValid

  # Set a field as required
  setFieldAsRequired: (record, field) ->
    error = gettext 'This field is required.'
    record.pushError(field, error)

  # Update registration info form depends on country
  registrationInfoView: Ember.ContainerView.extend
    childViews: ['registrationCountryType']

    registrationCountryType: Em.View.extend
      templateName: "tenants/add/registrationCountryType"
      select: Bootstrap.Forms.Select.extend
        init: ->
          @_super()
          countryCode = @get 'tenant.registrationInfo.countryCode'
          @set 'value', countryCode

        didInsertElement: ->
          @_super()
          countryCode = @get 'tenant.registrationInfo.countryCode'
          parentView = @get 'parentView.parentView'
          registrationCountryForm = parentView.createChildView Ember.View,
            templateName: "tenants/add/registrationInfo/#{countryCode}"
          parentView.pushObject registrationCountryForm

        change: ->
          countryCode = @get 'value'
          # Change registration info country. Keeps common informations
          oldRegistrationInfo = @get 'tenant.registrationInfo'
          newRegistrationInfo = oldRegistrationInfo.registrationInfoFor(countryCode).createRecord
            businessEntity: oldRegistrationInfo.get 'businessEntity'
            shareCapital: oldRegistrationInfo.get 'shareCapital'
          @set 'tenant.registrationInfo', newRegistrationInfo
          parentView = @get 'parentView.parentView'
          registrationCountryForm = parentView.get('childViews')[1]
          registrationCountryForm.set 'templateName', "tenants/add/registrationInfo/#{countryCode}"
          registrationCountryForm.rerender()