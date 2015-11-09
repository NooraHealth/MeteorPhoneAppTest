class @ModulesController
  @_nextButtonClasses = [ "slide-up", "scale-up", "expanded"]

  constructor: ( lessonId )->
    @._lesson = Lessons.findOne { "_id" : lessonId }
    @._sequence = @._lesson.getModulesSequence()

  getCurrentController: ()->
    return @._moduleController

  replay: ()->
    @._moduleController.replay()

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
    Scene.get().scrollToTop()
    @._currentModule = @._sequence[index]
    if @._moduleController
      @._moduleController.end()
    Router.go "module.show", { _id: @._currentModule._id }

    @._moduleController = ControllerFactory.get().getModuleController @._currentModule
    @._moduleController.begin()
    console.log "Going to module", @._currentModule._id

  notifyResponseRecieved: ( target )->
    @._moduleController.responseRecieved target

  shouldBeRendered: ( template )->
    console.log "Checking if should be rendered"
    return true

  currentModuleIndex: ()->
    return Session.get "current module index"

  goToNextModule: ()->
    index = Session.get "current module index"
    index++
    Session.update "current module index", index
    if index == @._sequence.length
      Scene.get().incrementCurrentLesson()
      Router.go "home"

    else
      @._goToModule index

  getSequence: ()->
    return @._sequence

  start: ()->
    Session.set "current module index", 0
    @._goToModule 0
    

