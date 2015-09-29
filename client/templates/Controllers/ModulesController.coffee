class ModulesController
  constructor: ( lessonId )->
    console.log "Making a modules sequence"
    @._lesson = Lessons.findOne { _id: @._lessonId }
    @._sequence = @._lesson.getModulesSequence()

  goToNextModule: ()->
    $(".")

  getModulesSequence: ()->
    return @._sequence

  start: ()->
    Router.go "modules.show", @.lesson._id

