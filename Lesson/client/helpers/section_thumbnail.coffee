Template.sectionThumbnail.helpers
  imageURL: ()->
    if _.isEmpty(@)
      return ""
    else
      return MEDIA_URL+ @.image
    
Template.sectionThumbnail.events
  'click .section-panel': (event, template) ->
    console.log "clickkkedd"
    #Router.go 'ModulesSequence'
