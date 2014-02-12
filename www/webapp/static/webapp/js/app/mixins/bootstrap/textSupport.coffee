Bootstrap.TextSupport = Ember.Mixin.create
  valueBinding: "parentView.value"
  placeholderBinding: "parentView.placeholder"
  disabledBinding: "parentView.disabled"
  maxlengthBinding: "parentView.maxlength"
  classNameBindings: "parentView.inputClassNames"
  classNames: ["form-control"]
  attributeBindings: ["name"]
  name: Ember.computed(->
    Ember.get(this, "parentView.name") or Ember.get(this, "parentView.label")
  ).property("parentView.name", "parentView.label").cacheable()