Template.sectionSidePanel.events
  
  'click .cd-panel-close': (event, template) ->
    event.preventDefault()
    console.log "removing class"
    $(".cd-panel").removeClass 'is-visible'

  'click .cd-panel': (event, template) ->
    event.preventDefault()
    console.log "removing class"
    $(".cd-panel").removeClass 'is-visible'

