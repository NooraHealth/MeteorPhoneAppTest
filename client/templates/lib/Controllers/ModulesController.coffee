class @ModulesController
  constructor: ( lessonId )->
    @._lesson = Lessons.findOne { "_id" : lessonId }
    @._sequence = @._lesson.getModulesSequence()

  _goToModule: ( index )->
    @._currentModule = @._sequence[@._index]
    if @._moduleController
      @._moduleController.end()
    @._moduleController = ControllerFactory.get().getModuleController @._currentModule
    @._moduleController.begin()

  goToNextModule: ()->
    @._index++
    if @._index == @._sequence.length
      Router.go "home"

    else
      @._goToModule @._index
      $(".ion-slide-box").slick("next")

  getSequence: ()->
    return @._sequence

  start: ()->
    @._index = 0
    @._goToModule @._index
    

