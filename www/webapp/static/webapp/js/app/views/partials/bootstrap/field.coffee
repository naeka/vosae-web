Bootstrap.Forms.Field = Ember.View.extend
  tagName: "div"
  classNameBindings: [":form-group", "isValid:has-no-error:has-error"]
  inputClassNames: ""
  labelCache: `undefined`
  help: `undefined`
  isValid: true
  templateName: "bootstrap/forms/field"
  
  label: Ember.computed((key, value) ->
    if arguments.length is 1
      if @get("labelCache") is `undefined`
        path = @get("valueBinding._from")
        if path
          path = path.split(".")
          path[path.length - 1]
      else
        @get "labelCache"
    else
      @set "labelCache", value
      value
  ).property()

  labelView: Ember.View.extend(
    tagName: "label"
    classNames: ["control-label"]
    template: Ember.Handlebars.compile("{{view.value}}")
    
    # If the labelCache property is present on parent, then the
    # label was set manually, and there's no need to humanise it.
    # Otherwise, it comes from the binding and needs to be
    # humanised.
    value: Ember.computed((key, value) ->
      parent = @get("parentView")
      if value and value isnt parent.get("label")
        parent.set "label", value
      else
        value = parent.get("label")
      (if parent.get("labelCache") is `undefined` or parent.get("labelCache") is false then Bootstrap.Forms.human(value) else value)
    ).property("parentView.label")
    inputElementId: "for"
    forBinding: "inputElementId"
    attributeBindings: ["for"]
  )

  inputField: Ember.View.extend(
    classNames: ["ember-bootstrap-extend", "form-control"]
    tagName: "div"
    template: Ember.Handlebars.compile("This class is not meant to be used directly, but extended.")

    init: ->
      @._super()
      @get('classNames').append @get('parentView.inputClassNames')
  )

  errorsView: Ember.View.extend(
    tagName: "div"
    classNameBindings: [":errors", ":help-inline"]
    template: Ember.Handlebars.compile("{{view.message}}")
    message: (->
      parent = @get("parentView")
      if parent?
        binding = parent.get("valueBinding._from")
        fieldName = null
        object = null
        if binding
          fieldName = binding.replace("_parentView.context.", "")
          object = parent.get("context")
        else
          fieldName = parent.get("label")
          object = parent.get("context")
        if object and not object.get("isValid")
          errors = object.get("errors")
          if errors and fieldName of errors and not Ember.isEmpty(errors[fieldName])
            parent.set "isValid", false
            return errors[fieldName].join ", "
          else
            parent.set "isValid", true
            return ""
        else
          parent.set "isValid", true
          return ""
    ).property("parentView.context.isValid", "parentView.label")
  )

  helpView: Ember.View.extend(
    tagName: "div"
    classNames: ["help-block"]
    template: Ember.Handlebars.compile("{{view.content}}")
    contentBinding: "parentView.help"
  )

  didInsertElement: ->
    @set "labelView.inputElementId", @get("inputField.elementId")