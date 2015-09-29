Template.lessonThumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
