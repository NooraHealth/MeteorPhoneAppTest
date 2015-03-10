Template.sectionSidePanel.events
  
  'click .cd-panel-close': (event, template) ->
    $("#panel" + @.nh_id).removeClass 'is-visible'

  'click .cd-panel': (event, template) ->
    $("#panel" + @.nh_id).removeClass 'is-visible'

