class @ModulesController
  constructor: ( lessonId )->
    console.log "Making a modules sequence"
    console.log lessonId
    @._lesson = Lessons.findOne { "_id" : lessonId }
    console.log @._lesson
    @._sequence = @._lesson.getModulesSequence()

  goToNextModule: ()->
    console.log "Going to the next module"
    $(".ion-slide-box").slick("next")

  getSequence: ()->
    return @._sequence

  start: ()->
    Router.go "modules.show", { "_id" : @._lesson._id }

