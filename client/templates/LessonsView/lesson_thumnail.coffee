Template.lessonThumbnail.helpers
  currentLesson: ()->
    #if not Template.currentData()
      #return false

    #index = Session.get "current lesson"
    #lessons = Scene.get().getCurriculum().lessons
    #return Template.currentData()._id == lessons[index]
    if Scene.get().getCurrentLesson() and Template.currentData()
      console.log "Returning the current lesson", Scene.get().getCurrentLesson()._id
      console.log Template.currentData()._id
      return Scene.get().getCurrentLesson()._id == Template.currentData()._id
    else
      return true

Template.lessonThumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
