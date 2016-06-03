
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
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

  @getCurrentModuleId = =>
    @state.get "currentModuleId"

  @setCurrentModuleId = =>
    index = @state.get "moduleIndex"
    moduleId = @getLesson()?.modules[index]
    @state.set "currentModuleId", moduleId

  @getCurrentModule = =>
    id = @getCurrentModuleId()
    return Modules.findOne {_id: id}

  @isCurrent = (moduleId) =>
    current = @getCurrentModuleId()
    return moduleId is current

  @isCompleted = (moduleId) =>
    modules = @getLesson()?.modules
    index = @state.get "moduleIndex"
    return index > modules?.indexOf moduleId

  @trackAudioStopped = (pos, completed, src) =>
    lesson = @getLesson()
    condition = AppState.get().getCondition()
    language = AppState.get().getLanguage()
    module = @getCurrentModule()
    text = if module.title then module.title else module.question
    analytics.track "Audio Stopped", {
      moduleText: text
      audioSrc: src
      moduleId: module._id
      language: language
      condition: condition
      time: pos
      completed: completed
      lessonTitle: lesson.title
      lessonId: lesson._id
    }

  @trackResponsedToQuestion = =>
    lesson = @getLesson()
    condition = AppState.get().getCondition()
    language = AppState.get().getLanguage()
    module = @getCurrentModule()
    text = if module.title then module.title else module.question
    analytics.track "Responded to Question", {
      moduleId: module._id
      moduleText: text
      choice: choice
      lessonTitle: lesson.title
      lessonId: lesson._id
      condition: condition
      language: language
      type: type
    }

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

  @onFinishExplanation = (pos, completed, src) =>
    @state.set "nextButtonAnimated", true
    @trackAudioStopped( pos, completed, src)

  @onChoice = (instance, type, showAlert) ->
    return (choice) ->
      if type is "CORRECT"
        instance.state.set "soundEfffectPlaying", "CORRECT"
        alertType = 'success'
      else
        instance.state.set "soundEfffectPlaying", "INCORRECT"
        alertType = 'error'
      if showAlert
        swal {
          title: ""
          type: alertType
          timer: 3000
        }

      #analytics
      instance.trackResponsedToQuestion()

  @onCompletedQuestion = (instance) ->
    return ->
      instance.state.set "audioPlaying", "EXPLANATION"

  @stopPlayingSoundEffect = =>
    @state.set "soundEfffectPlaying", null

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
    @goHome(true)

  @goHome = (completedLesson) ->
    lesson = @getLesson()
    module = @getCurrentModule()
    text = if module.title then module.title else module.question
    analytics.track "Left Lesson For Home", {
      lessonTitle: lesson.title
      lessonId: lesson._id
      lastModuleId: module._id
      lastModuleText: text
      lastModuleType: module.type
      completedLesson: completedLesson
      numberOfModulesInLesson: lesson.modules.length
    }

    FlowRouter.go "home"

  @goToNextModule = =>
    console.log "Going to next module"
    console.log "-----------------------"
    index = @state.get "moduleIndex"
    newIndex = ++index
    @state.set "moduleIndex", newIndex
    @state.set "nextButtonAnimated", false
    @setCurrentModuleId()

    module = @getCurrentModule()
  
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
    if @lessonComplete() then @celebrateCompletion() else @goToNextModule()

  @nextButtonText = => if @lessonComplete() then "FINISH" else "NEXT"

  @afterReplay = =>
    @state.set "replayAudio", false

  @onReplayButtonClicked = =>
    @state.set "replayAudio", true

  @shouldShowReplayButton = =>
    module = @getCurrentModule()
    return module?.type isnt "VIDEO"

  @onPlayVideo = =>
    @state.set "playingVideo", true

  @onStopVideo = =>
    @state.set "playingVideo", false

  @onVideoEnd = =>
    @state.set "playingVideo", false
    @state.set "nextButtonAnimated", true

  @videoPlaying = =>
    playing = @state.get "playingVideo"
    if playing? then return playing else return false

  @shouldPlayQuestionAudio = (id) =>
    isPlayingQuestion = @state.get "playingQuestion"
    return @isCurrent(id) and isPlayingQuestion

  @shouldPlayExplanationAudio = (id) =>
    shouldPlay = @state.get "playingExplanation"
    if @isCurrent(id) and shouldPlay then return true else return false

  @autorun =>
    lessonId = @getLessonId()
    #@subscribe "lesson", lessonId
    #@subscribe "modules.inLesson", lessonId

  @autorun =>
    if ContentInterface.get().subscriptionsReady(@)
      @setCurrentModuleId()

Template.Lesson_view_page.helpers
  modulesReady: ->
    instance = Template.instance()
    #return ContentInterface.get().subscriptionsReady(instance)
    return instance.subscriptionsReady()

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
        shouldShow: instance.shouldShowReplayButton
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
        onPlayVideo: instance.onPlayVideo
        onStopVideo: instance.onStopVideo
        onVideoEnd: instance.onVideoEnd
        playing: instance.isCurrent(module._id) and instance.videoPlaying()
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
      whenPaused: instance.trackAudioStopped
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
      whenFinished: instance.trackAudioStopped
      whenPaused: instance.trackAudioStopped
    }

  incorrectSoundEffectArgs: ->
    instance = Template.instance()
    playing = instance.state.get("soundEfffectPlaying") == "INCORRECT"
    return {
      attributes: {
        src: ContentInterface.get().getSrc(ContentInterface.get().incorrectSoundEffectFilePath())
      }
      playing: playing
      whenFinished: instance.stopPlayingSoundEffect
      whenPaused: instance.stopPlayingSoundEffect
    }

  correctSoundEffectArgs: ->
    instance = Template.instance()
    playing = instance.state.get("soundEfffectPlaying") == "CORRECT"
    return {
      attributes: {
        src: ContentInterface.get().getSrc(ContentInterface.get().correctSoundEffectFilePath())
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
