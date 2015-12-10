class @ModulesController
  @_nextButtonClasses = [ "slide-up", "scale-up", "expanded"]

  constructor: ( lessonId )->
    @._lesson = Lessons.findOne { "_id" : lessonId }
    @._sequence = @._lesson.getModulesSequence()
    @._alreadyPlayedIntro = []

  getCurrentController: ()->
    return @._moduleController

  replay: ()->
    @._moduleController.replay()

  stopAllAudio: ()->
    if @._moduleController and @._moduleController.stopAllAudio
      @._moduleController.stopAllAudio()

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
    $("audio").each (elem)->
      $(elem).remove()

    @._currentModule = @._sequence[index]
    if @._moduleController
      @._moduleController.end()

    Session.set "current module id", @._currentModule._id
    $("body").append "<audio id='audio"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='correctaudio"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='correct_soundeffect"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='incorrect_soundeffect"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='intro"+@._currentModule._id+"'></audio>"

    @._moduleController = ControllerFactory.get().getModuleController @._currentModule
    @._moduleController.begin( @.shouldPlayIntro @._currentModule.type )

  shouldPlayIntro: ( type )->
    return false
#    if type in @._alreadyPlayedIntro
      #return false
    #else
      #@._alreadyPlayedIntro.push type
      #return true

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
      Scene.get().goToLessonsPage()
      congratulations = new Accolade()
      congratulations.sendAccolade()
    else
      @._goToModule index

  getSequence: ()->
    return @._sequence

  start: ()->
    console.log "Starting the sequence"
    Session.set "current module index", 0
    @._goToModule 0
    

