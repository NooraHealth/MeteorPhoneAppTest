Template.Home_thumbnail.helpers
  currentLesson: (lesson) ->
    console.log "Here is the lesson", lesson._id
    console.log Scene.get().getCurrentLesson()._id
    if Scene.get().getCurrentLesson() and lesson
      return Scene.get().getCurrentLesson()._id == lesson._id
    else
      return true

Template.Home_thumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
