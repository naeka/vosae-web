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

    context = @get 'context'
    value = @get 'currentItem.description'
    if value
      editor.setData value

    # Editor -> Model
    editor.on 'change', =>
      @set 'currentItem.description', editor.getData()

    context.set 'editor', editor
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
    context = @get 'context'
    editor = context.get 'editor'
    value = @get('currentItem.description')
    if not Em.isEqual value, editor.getData()
      editor.setData @get('value')
  ).observes "value"
