class @ModulesController
  constructor: ( lessonId )->
    console.log "Making a modules sequence"
    console.log lessonId
    @._lesson = Lessons.findOne { "_id" : lessonId }
    console.log @._lesson
    @._sequence = @._lesson.getModulesSequence()

  goToNextModule: ()->
    @._index++
    if @._index == @._sequence.length
      Router.go "home"

    @._currentModule = @._sequence[@._index]
    $(".ion-slide-box").slick("next")

  getSequence: ()->
    return @._sequence

  start: ()->
    Router.go "modules.show", { "_id" : @._lesson._id }
    @._index = 0
    @._currentModule = @._sequence[@._index]
    @._moduleController = ModuleFactory.get @._currentModule
    

