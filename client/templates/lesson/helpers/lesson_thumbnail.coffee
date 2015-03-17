 
Template.lessonThumbnail.events
  'click .lesson-panel':(event, template)->
    $("#panel" + @.nh_id).addClass 'is-visible'




