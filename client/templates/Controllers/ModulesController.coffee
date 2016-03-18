class @ModulesController

  constructor: ( lessonId )->
    @._lesson = Lessons.findOne { "_id" : lessonId }
    @._sequence = @._lesson.getModulesSequence()
    @._alreadyPlayedIntro = []
    @._nextBtn = NextButton.get()

  getCurrentController: ()->
    return @._moduleController

  replay: ()->
    @._moduleController.replay()

  stopAllAudio: ()->
    if @._moduleController and @._moduleController.stopAllAudio
      @._moduleController.stopAllAudio()

  @setContentBlurred: ( state )->
    Session.set "module content blurred", state

  @readyForNextModule: ()->
    NextButton.get().shake()
    #ModulesController.setContentBlurred true

  _goToModule: ( index )->
    Scene.get().scrollToTop()
    $("audio").each (elem)->
      $(elem).remove()

    @._currentModule = @._sequence[index]
    if @._moduleController
      @._moduleController.end()

    #Session.set "current module id", @._currentModule._id
    FlowRouter.go "/module/" + @._currentModule._id
    $("body").append "<audio id='audio"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='correctaudio"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='correct_soundeffect"+@._currentModule._id+"'></audio>"
    $("body").append "<audio id='incorrect_soundeffect"+@._currentModule._id+"'></audio>"

    @._moduleController = ControllerFactory.get().getModuleController @._currentModule
    @._moduleController.begin()

  notifyResponseRecieved: ( target )->
    @._moduleController.responseRecieved target

  currentModuleIndex: ()->
    return Session.get "current module index"

  goToNextModule: ()->
    index = Session.get "current module index"
    index++
    Session.update "current module index", index
    NextButton.get().stopShake()
    #ModulesController.setContentBlurred false

    if index == @._sequence.length-1
      NextButton.get().changeButtonText "FINISH"

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
    Session.set "current module index", 0
    @._goToModule 0
    

