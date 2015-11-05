Template.lessonThumbnail.helpers
  curriculumTitle: ()->
    return Scene.get().getCurriculum().title
  currentLesson: ()->
    if Scene.get().getCurrentLesson() and Template.currentData()
      return Scene.get().getCurrentLesson()._id == Template.currentData()._id
    else
      return true

Template.lessonThumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
