Template.lessonThumbnail.helpers
  currentLesson: ()->
    #if not Template.currentData()
      #return false

    #index = Session.get "current lesson"
    #lessons = Scene.get().getCurriculum().lessons
    #return Template.currentData()._id == lessons[index]
    console.log "Getting the current lesson in current:Leson template helper"
    console.table Lessons.find({}).count()
    if Scene.get().getCurrentLesson() and Template.currentData()
      console.log "Returning the current lesson", Scene.get().getCurrentLesson()._id
      console.log Template.currentData()._id
      return Scene.get().getCurrentLesson()._id == Template.currentData()._id
    else
      return true

Template.lessonThumbnail.events
  'click' : ( e )->
    console.log "CLICKING A SCRENE"
    Scene.get().goToModules( Template.currentData()._id )

  
