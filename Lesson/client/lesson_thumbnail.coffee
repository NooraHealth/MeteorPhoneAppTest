Template.lessonThumbnail.helpers
  imageURL: ()->
    if _.isEmpty(@)
      return ""
    else
      return MEDIA_URL+ @.image
    
Template.lessonThumbnail.events
  'click .lesson-panel':(event, template)->
    $("#panel" + @.nh_id).addClass 'is-visible'




