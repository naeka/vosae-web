Vosae.Components.SimpleEditor = Em.TextArea.extend
  maxLength: 512
  placeholder: null
    
  didInsertElement: ->
    @_super()

    editor = CKEDITOR.inline @get('elementId'),
      customConfig: false
      stylesSet: false
      language: Vosae.currentLanguage
      extraPlugins: 'wordcount,confighelper'
      toolbar: [
        ['Bold', 'Italic', 'Underline'],
        ['Undo', 'Redo'],
      ]
      placeholder: @get('placeholder')
      allowedContent: 'b i u br'
      forcePasteAsPlainText: true
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

    context = @get 'context'
    value = @get 'value'
    if value
      editor.setData value, undefined, true
    context.set 'editor', editor

    editor.on 'change', =>
      @set 'value', editor.getData()

  willDestroyElement: ->
    context = @get 'context'
    editor = context.get 'editor'
    editor.destroy false

  valueChanged: (->
    context = @get 'context'
    editor = context.get 'editor'
    value = @get('value')
    if not Em.isEqual value, editor.getData()
      editor.setData @get('value')
  ).observes('value')
