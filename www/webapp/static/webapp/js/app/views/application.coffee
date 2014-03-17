Vosae.ApplicationView = Em.View.extend
  elementId: "wrapper"

  # HTML events handlers
  drop: (e) ->
    e.preventDefault()
    $("body").removeClass "draggingOn"

  dragOver: (e) ->
    e.preventDefault()

  dragEnter: (e) ->
    $("body").addClass "draggingOn"
  
  dragLeave: (e) ->
    if e.originalEvent.clientX <= 0 or e.originalEvent.clientY <= 0
      $("body").removeClass "draggingOn"

