Template.lessonThumbnail.helpers
  currentLesson: ()->
    #if not Template.currentData()
      #return false

    #index = Session.get "current lesson"
    #lessons = Scene.get().getCurriculum().lessons
    #return Template.currentData()._id == lessons[index]
    console.log "Template current Data"
    console.log Template.currentData()
    console.log "Current lesson"
    console.log Scene.get().getCurrentLesson()
    if Scene.get().getCurrentLesson() and Template.currentData()
      return Scene.get().getCurrentLesson()._id == Template.currentData()._id
    else
      return true

Template.lessonThumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
