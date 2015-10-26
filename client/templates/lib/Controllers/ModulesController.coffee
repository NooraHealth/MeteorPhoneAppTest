class @ModulesController
  constructor: ( lessonId )->
    @._lesson = Lessons.findOne { "_id" : lessonId }
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
    @._index = 0
    @._currentModule = @._sequence[@._index]
    console.log "Getting the modules controller"
    @._moduleController = ControllerFactory.get().getModuleController @._currentModule
    console.log @._moduleController
    

