Template.lessonThumbnail.helpers
  currentLesson: ()->
    return Scene.get().getCurrentLesson()._id == Template.currentData()._id

Template.lessonThumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
