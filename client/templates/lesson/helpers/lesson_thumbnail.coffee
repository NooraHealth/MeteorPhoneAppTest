 
Template.lessonThumbnail.events
  'click .lesson-panel':(event, template)->
    parentLesson = @.nh_id
    sectionsMap = Session.get "sections map"
    Session.set "current sections", sectionsMap[@.nh_id]
    $("#panel" + @.nh_id).addClass 'is-visible'



