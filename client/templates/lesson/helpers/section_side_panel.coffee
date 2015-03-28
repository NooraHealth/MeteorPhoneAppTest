Template.sectionSidePanel.helpers
  sections: ()->
    if _.isEmpty(@)
      return []
    else
      if @.has_sublessons == 'false'
        return [@]
      else
        return @.getSublessonDocuments()

Template.sectionSidePanel.events
 
  'click .cd-panel-close': (event, template) ->
    $("#panel" + @.nh_id).removeClass 'is-visible'

  'click .cd-panel': (event, template) ->
    $("#panel" + @.nh_id).removeClass 'is-visible'

  'click [name=section_thumbnail]': (event, template) ->
    console.log "this is the event", event
    console.log "this is the template", template

