
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ Modules } = require("meteor/noorahealth:mongo-schemas")

{ AppState } = require('../../api/AppState.coffee')
{ Award } = require('../components/lesson/awards/award.coffee')
{ ContentInterface }= require('../../api/content/ContentInterface.coffee')

require './lesson_view.html'
require '../components/lesson/modules/binary.coffee'
require '../components/lesson/modules/scenario.coffee'
require '../components/lesson/modules/multiple_choice/multiple_choice.coffee'
require '../components/lesson/modules/slide.html'
require '../components/lesson/modules/video.coffee'
require '../components/lesson/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->
  @state = new ReactiveDict()
  @state.setDefault {
    moduleIndex: 0
    currentModuleId: null
    correctlySelectedClasses: 'correctly-selected expanded'
    incorrectClasses: 'faded'
    incorrectlySelectedClasses: 'incorrectly-selected'
    nextButtonAnimated: false
    soundEfffectPlaying: null
    audioPlaying: "QUESTION"
  }

  @setCurrentModuleId = =>
    index = @state.get "moduleIndex"
    moduleId = @getLesson()?.modules[index]
    @state.set "currentModuleId", moduleId

  @isCurrent = (moduleId) =>
    current = @state.get "currentModuleId"
    return moduleId is current

  @isCompleted = (moduleId) =>
    modules = @getLesson()?.modules
    index = @state.get "moduleIndex"
    return index > modules?.indexOf moduleId

  @getPagesForPaginator = =>
    modules = @getModules()
    if not modules?
      return []
    else
      getPageData = (module, i) =>
        data = {
          completed: @isCompleted module._id
          current: @isCurrent module._id
          index: i+1
        }
        return data
      pages = ( getPageData(module, i) for module, i in modules )
      return pages

  @onPauseExplanation = =>
    #@state.set "playingExplanation", false
    #@state.set "audioPlaying", null

  @onFinishExplanation = =>
    #@state.set "audioPlaying", null
    #@state.set "playingExplanation", false
    @state.set "nextButtonAnimated", true

  @onChoice = (instance, type, showAlert) ->
    return ->
      if type is "CORRECT"
        instance.state.set "soundEfffectPlaying", "CORRECT"
        #instance.state.set "playingCorrectSoundEffect", true
        #instance.state.set "playingIncorrectSoundEffect", false
        alertType = 'success'
      else
        instance.state.set "soundEfffectPlaying", "INCORRECT"
        #instance.state.set "playingIncorrectSoundEffect", true
        #instance.state.set "playingCorrectSoundEffect", false
        alertType = 'error'
      if showAlert
        swal {
          title: ""
          type: alertType
          timer: 3000
        }

  @onCompletedQuestion = (instance) ->
    return ->
      instance.state.set "audioPlaying", "EXPLANATION"
      #instance.state.set "playingQuestion", false
      #instance.state.set "playingExplanation", true

  @stopPlayingSoundEffect = =>
    @state.set "soundEfffectPlaying", null
    #@state.set "playingCorrectSoundEffect", false
    #@state.set "playingIncorrectSoundEffect", false

  @lessonComplete = =>
    lesson = @getLesson()
    index = @state.get "moduleIndex"
    return index == lesson?.modules?.length-1

  @getModules = =>
    return @getLesson()?.getModulesSequence()

  @getLessonId = =>
    return FlowRouter.getParam "_id"

  @getLesson = =>
    id = @getLessonId()
    lesson = Lessons.findOne { _id: id }
    return lesson

  @celebrateCompletion = =>
    AppState.get().incrementLesson()
    new Award().sendAward()
    @goHome()

  @goHome = ->
    FlowRouter.go "home"

  @goToNextModule = =>
    index = @state.get "moduleIndex"
    newIndex = ++index
    @state.set "moduleIndex", newIndex
    @state.set "nextButtonAnimated", false
    #@state.set "playingQuestion", true
    @state.set "audioPlaying", "QUESTION"
    @setCurrentModuleId()
  
  @onNextButtonRendered = =>
    mySwiper = App.swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      nextButton: '.swiper-button-next',
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

  @onNextButtonClicked = =>
    #remove .active-state class if it exists (Framework7 bug hackaround)
    if @lessonComplete() then @celebrateCompletion() else @goToNextModule()

  @nextButtonText = => if @lessonComplete() then "FINISH" else "NEXT"

  @afterReplay = =>
    @state.set "replayAudio", false

  @onReplayButtonClicked = =>
    console.log "Replay button clicked"
    @state.set "replayAudio", true

  @shouldPlayQuestionAudio = (id) =>
    console.log "SHould play question audio??"
    isPlayingQuestion = @state.get "playingQuestion"
    console.log(@isCurrent(id) and isPlayingQuestion)
    return @isCurrent(id) and isPlayingQuestion

  @shouldPlayExplanationAudio = (id) =>
    shouldPlay = @state.get "playingExplanation"
    if @isCurrent(id) and shouldPlay then return true else return false

  @autorun =>
    lessonId = @getLessonId()
    @subscribe "lesson", lessonId
    @subscribe "modules.inLesson", lessonId

  @autorun =>
    console.log "Subscriptions ready?"
    console.log @subscriptionsReady()
    if @subscriptionsReady()
      @setCurrentModuleId()

Template.Lesson_view_page.helpers
  modulesReady: ->
    instance = Template.instance()
    ContentInterface.get().subscriptionsReady(instance)

  footerArgs: ->
    instance = Template.instance()
    return {
      homeButton: {
        onClick: instance.goHome
      }
      nextButton: {
        onClick: instance.onNextButtonClicked
        text: instance.nextButtonText()
        onRendered: instance.onNextButtonRendered
        animated: instance.state.get("nextButtonAnimated")
      }
      replayButton: {
        onClick: instance.onReplayButtonClicked
      }
      pages: instance.getPagesForPaginator()
    }

  lessonTitle: ->
    instance = Template.instance()
    return instance.getLesson()?.title

  moduleArgs: (module) ->
    instance = Template.instance()
    isQuestion = (type) ->
      return type == "BINARY" or type == "SCENARIO" or type == "MULTIPLE_CHOICE"

    if isQuestion module.type
      showAlert = if module.type == 'MULTIPLE_CHOICE' then false else true
      return {
        module: module
        incorrectClasses: instance.state.get "incorrectClasses"
        incorrectlySelectedClasses: instance.state.get "incorrectlySelectedClasses"
        correctlySelectedClasses: instance.state.get "correctlySelectedClasses"
        onCorrectChoice: instance.onChoice(instance, "CORRECT", showAlert)
        onWrongChoice: instance.onChoice(instance, "WRONG", showAlert)
        onCompletedQuestion: instance.onCompletedQuestion(instance)
      }
    else if module.type == "VIDEO"
      return {
        module: module
        playing: instance.isCurrent module._id
      }
    else
      return {module: module}

  hasAudio: (module) ->
    return module.audio?

  hasExplanation: (module) ->
    return module.correct_audio?

  explanationArgs: (module) ->
    instance = Template.instance()
    playing = instance.state.get("audioPlaying") == "EXPLANATION"
    replay = instance.state.get("replayAudio")
    isCurrent = instance.isCurrent(module._id)
    return {
      attributes: {
        src: ContentInterface.get().getSrc module.correct_audio
      }
      playing: playing and isCurrent
      replay: playing and replay and isCurrent
      afterReplay: instance.afterReplay
      whenFinished: instance.onFinishExplanation
      whenPaused: instance.onPauseExplanation
    }

  audioArgs: (module) ->
    instance = Template.instance()
    playing = instance.state.get("audioPlaying") == "QUESTION"
    replay = instance.state.get("replayAudio")
    isCurrent = instance.isCurrent(module._id)
    return {
      attributes: {
        src: ContentInterface.get().getSrc module.audio
      }
      playing: playing and isCurrent
      replay: playing and replay and isCurrent
      afterReplay: instance.afterReplay
    }

  incorrectSoundEffectArgs: ->
    instance = Template.instance()
    playing = instance.state.get("soundEfffectPlaying") == "INCORRECT"
    return {
      attributes: {
        src: ContentInterface.get().incorrectSoundEffectFilePath()
      }
      playing: playing
      whenFinished: instance.stopPlayingSoundEffect
      whenPaused: instance.stopPlayingSoundEffect
    }

  correctSoundEffectArgs: ->
    instance = Template.instance()
    console.log "Changing the correct sound effect args"
    console.log instance.state.get("playingCorrectSoundEffect")
    playing = instance.state.get("soundEfffectPlaying") == "CORRECT"
    return {
      attributes: {
        src: ContentInterface.get().correctSoundEffectFilePath()
      }
      playing: playing
      whenFinished: instance.stopPlayingSoundEffect
      whenPaused: instance.stopPlayingSoundEffect
    }

  modules: ->
    instance = Template.instance()
    return instance.getModules()

  getTemplate: (module) ->
    if module?.type == "BINARY"
      return "Lesson_view_page_binary"
    if module?.type == "MULTIPLE_CHOICE"
      return "Lesson_view_page_multiple_choice"
    if module?.type == "SCENARIO"
      return "Lesson_view_page_scenario"
    if module?.type == "VIDEO"
      return "Lesson_view_page_video"
    if module?.type == "SLIDE"
      return "Lesson_view_page_slide"

Template.Lesson_view_page.onRendered ()->
