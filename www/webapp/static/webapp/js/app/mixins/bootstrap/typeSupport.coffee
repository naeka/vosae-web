Bootstrap.TypeSupport = Ember.Mixin.create
  baseClassName: Ember.required(String)
  classNameBindings: ["typeClass"]
  type: null # success, warning, error, info || inverse
  typeClass: Ember.computed(->
    type = Ember.get(this, "type")
    baseClassName = Ember.get(this, "baseClassName")
    (if type then baseClassName + "-" + type else null)
  ).property("type").cacheable()