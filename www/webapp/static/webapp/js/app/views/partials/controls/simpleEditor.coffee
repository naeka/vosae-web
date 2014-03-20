###
  This render a simple editor with CKEditor

  @class SimpleEditor
  @extends Ember.TextArea
  @namespace Vosae
  @module Vosae
###

Vosae.SimpleEditor = Em.TextArea.extend
  maxLength: 512
  placeholder: null

  checkModelValue: (->
    Ember.Logger.error(@toString() + " needs the `model` property to be defined.") if Em.isNone @get("model")
  ).on "init"

  initCKEditor: (->
    # We don't want CKEditor to load any stylesheets
    CKEDITOR.skin.loadPart = (part, callback) -> callback && callback()

    editor = CKEDITOR.inline @get('elementId'),
      customConfig: false
      stylesSet: false
      language: Vosae.Config.currentLanguage
      extraPlugins: 'wordcount,confighelper'
      toolbar: [
        ['Bold', 'Italic', 'Underline'],
        ['Undo', 'Redo'],
      ]
      placeholder: @get('placeholder')
      allowedContent: 'b i u br'
      entities: false
      forcePasteAsPlainText: true
      fillEmptyBlocks: false
      autoParagraph: false
      enterMode: CKEDITOR.ENTER_BR
      coreStyles_bold:
        element: 'b'
        overrides: 'strong'
      coreStyles_italic:
        element: 'i'
        overrides: 'em'
      wordcount:
        charLimit: @get 'maxLength'
        countHTML: true

    # Empty title, this prevent us to have a title
    # like 'Rich text editor, ember 1924'
    editor.title = ''

    # Put editor in the context
    context = @get 'context'
    context.set 'editor', editor
    
    # Set initial value to editor's data
    initValue = @getModelValue()
    @setEditorValue initValue if initValue

    # Editor -> Model
    editor.on 'change', =>
      @setModelValue editor.getData()

  ).on "didInsertElement"
  
  destroyCKEditor: (->
    # try / catch is needed to prevent an error due to a bug on CKEDITOR
    # `Cannot call method 'clearCustomData' of undefined`
    try
      context = @get 'context'
      editor = context.get 'editor'
      editor.destroy false
  ).on "willDestroyElement"

  # Model -> Editor
  valueChanged: (->
    value = @getModelValue()
    if not Em.isEqual value, @getEditorValue()
      @setEditorValue value
  ).observes "value"

  getModelValue: ->
    key = @get("valueBinding._from").split('.').get('lastObject')
    @get("model").get(key)

  getEditorValue: ->
    @get('context.editor').getData()

  setModelValue: (newValue) ->
    key = @get("valueBinding._from").split('.').get('lastObject')
    @get("model").set key, newValue

  setEditorValue: (newValue) ->
    @get('context.editor').setData newValue

Vosae.View.registerHelper "simple-editor", Vosae.SimpleEditor