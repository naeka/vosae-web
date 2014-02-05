Bootstrap.FocusSupport = Ember.Mixin.create
  attributeBindings: ["autofocus"] #HTML5 autofocus see http://diveintohtml5.info/forms.html#autofocus
  didInsertElement: ->
    @_super()
    if @get("autofocus")
      Ember.run.schedule "actions", this, ->
        @$().focus()
