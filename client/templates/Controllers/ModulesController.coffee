class @ModulesController
  @_nextButtonClasses = [ "scale-up", "expanded"]

  constructor: ( lessonId )->
    @._lesson = Lessons.findOne { "_id" : lessonId }
    @._sequence = @._lesson.getModulesSequence()


  @showResponsePopUp: ( id )->
    console.log "Showing the response popup!"
    delay = (ms, func) -> setTimeout func, ms
    popup = $(id)
    popup.addClass "show-pop-up"
    delay 2000, ()-> popup.removeClass "show-pop-up"

  @shakeNextButton: ()->
    btn = $("#next")
    for klass in ModulesController._nextButtonClasses
      if not btn.hasClass klass
        btn.addClass klass

  @stopShakingNextButton: ()->
    btn = $("#next")
    for klass in ModulesController._nextButtonClasses
      if btn.hasClass klass
        btn.removeClass klass

  _goToModule: ( index )->
    @._currentModule = @._sequence[@._index]
    if @._moduleController
      @._moduleController.end()
    @._moduleController = ControllerFactory.get().getModuleController @._currentModule
    @._moduleController.begin()

  notifyResponseRecieved: ( target )->
    @._moduleController.responseRecieved target

  goToNextModule: ()->
    @._index++
    if @._index == @._sequence.length
      Scene.get().incrementCurrentLesson()
      Router.go "home"

    else
      @._goToModule @._index
      $(".ion-slide-box").slick("next")

  getSequence: ()->
    return @._sequence

  start: ()->
    @._index = 0
    @._goToModule @._index
    

