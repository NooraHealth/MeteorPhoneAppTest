Template.sectionSidePanel.helpers
  sections: ()->
    if _.isEmpty(@)
      return []
    else
      if @.has_sections == 'false'
        return [@]
      else
        lessonNh_id = @.nh_id
        sectionsMap = Session.get "sections map"
        return sectionsMap[lessonNh_id]
      

Template.sectionSidePanel.events
 
  'click .cd-panel-close': (event, template) ->
    $("#panel" + @.nh_id).removeClass 'is-visible'

  'click .cd-panel': (event, template) ->
    $("#panel" + @.nh_id).removeClass 'is-visible'


