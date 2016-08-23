
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ Modules } = require("meteor/noorahealth:mongo-schemas")

{ AppState } = require('../../api/AppState.coffee')
{ Award } = require('../components/lesson/popups/award.coffee')
{ Audio } = require('../components/audio/audio.coffee')
{ IntroductionToQuestions } = require('../components/lesson/popups/introduction_to_questions.coffee')
{ ContentInterface }= require('../../api/content/ContentInterface.coffee')
{ TAPi18n } = require("meteor/tap:i18n")
{ ReactiveVar } = require("meteor/reactive-var")

require './lesson_view.html'
require '../components/lesson/modules/binary.coffee'
require '../components/lesson/modules/scenario.coffee'
require '../components/lesson/modules/multiple_choice/multiple_choice.coffee'
require '../components/lesson/modules/slide.html'
require '../components/lesson/modules/video.coffee'
require '../components/lesson/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->


  @state = new ReactiveDict()

  @setStateToDefault = =>
    @state.set {
      moduleIndex: 0
      correctlySelectedClasses: 'correctly-selected expanded'
      incorrectClasses: 'faded'
      incorrectlySelectedClasses: 'incorrectly-selected'
      nextButtonAnimated: false
      #soundEffectPlaying: null
      #audioPlaying: null
      nextButtonAnimated: false
      lessonIndex: 0
      homePage: true
      #playStub: false
    }

  @state.set "level", AppState.getLevels()[0].name
  @liveAudio = []
  @HOME_SLIDE_INDEX = 0

  @onLevelSelected = ( levelName ) =>
    @setLevel levelName

    lessons = @getLessons()
    if lessons.length > 0
      @startLesson(0)
    else
      swal {
        title: "Oops!"
        text: "We don't have lessons available for that level yet"
      }

  @getModuleIndex = =>
    return @state.get "moduleIndex"

  @setModuleIndex = (index) =>
    @state.set "moduleIndex", index

  @getCurrentModule = =>
    index = @state.get "moduleIndex"
    return @getModules()?[index]

  @setPlayStub = (shouldPlay) ->
    @state.set "playStub", shouldPlay

  @isCurrent = (moduleId) =>
    currentModule = @getCurrentModule()
    return moduleId is currentModule._id

  #@isCompleted = (moduleId) =>
    #modules = @getModules()
    #index = @getModuleIndex()
    #return index > modules?.indexOf moduleId

  @getProgress = ()=>
    numInLesson = @getModules()?.length or 0
    numCompleted = @getModuleIndex() + 1
    return (numCompleted * 100 / numInLesson).toString()

  @trackAudioStopped = (pos, completed, src) =>
    lesson = @getCurrentLesson()
    condition = AppState.getCondition()
    language = AppState.getLanguage()
    module = @getCurrentModule()
    text = if module?.title then module?.title else module?.question
    analytics.track "Audio Stopped", {
      moduleText: text
      audioSrc: src
      moduleId: module?._id
      language: language
      condition: condition
      time: pos
      completed: completed
      lessonTitle: lesson?.title
      lessonId: lesson?._id
    }
    @

  @onFinishExplanation = (module, pos, completed, src)=>
    currentModule = @getCurrentModule()
    if @isCurrent module._id
      @setNextButtonAnimated true
      #@setAudioPlaying null
    @trackAudioStopped( pos, completed, src )

  @onChoice = (instance, type, showAlert) ->
    return (choice) ->
      if type is "CORRECT"
        instance.playAudio(ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 1)
        alertType = 'success'
      else
        instance.playAudio(ContentInterface.getSrc(ContentInterface.incorrectSoundEffectFilename(), "AUDIO"), 1)
        alertType = 'error'
        module = instance.getCurrentModule()
      if showAlert
        language = AppState.getLanguage()
        swal {
          title: ""
          type: alertType
          timer: 3000
          confirmButtonText: AppState.translate "ok", language
        }

      #analytics
      lesson = instance.getCurrentLesson()
      condition = AppState.getCondition()
      language = AppState.getLanguage()
      module = instance.getCurrentModule()
      text = if module?.title then module?.title else module?.question
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

  @playAudio = (src, volume, whenFinished, whenPaused) =>
    audio = new Audio src, volume
    audio.play whenFinished, whenPaused
    @liveAudio.push audio
    return audio

  @setCurrentAudio = (audio) ->
    @currentAudio = audio
    @

  @onCompletedQuestion = (module) ->
    @stopAudio()
    audio = @playAudio ContentInterface.getSrc(module.correct_audio, "AUDIO"), 1, @onFinishExplanation.bind(@, module), @onFinishExplanation.bind(@, module)
    @setCurrentAudio audio
    @

  #@stopPlayingSoundEffect = =>
    #@state.set "soundEffectPlaying", null

  @lessonComplete = =>
    index = @getModuleIndex()
    modules = @getModules()
    if modules then return index == @getModules()?.length-1 else return false

  @getModules = =>
    lesson = @getCurrentLesson()
    modules = @getCurrentLesson()?.getModulesSequence()
    return modules

  @getCurrentLesson = =>
    lessonIndex = @getLessonIndex()
    return @getLessons()?[lessonIndex]

  @setLevel = (level) =>
    console.log "Setting the level to "
    console.log level
    @state.set "level", level

  @getLevel = =>
    @state.get "level"

  @getLessons = =>
    level = @getLevel()
    return AppState.getLessonDocs( level )
  
  @isLastLesson = =>
    lessonIndex = @getLessonIndex()
    return lessonIndex == @getLessons().length - 1

  @celebrateCompletion = =>
    language = AppState.getLanguage()
    lessonIndex = @state.get "lessonIndex"
    lessonsComplete = lessonIndex + 1
    totalLessons = @getLessons().length
    onConfirm = ()=>
      @goToNextLesson()

    onCancel = ()=>
      @goHome(null, false)
    
    isLastLesson = @isLastLesson()
    if @isLastLesson()
      new Award(language).sendAward( null, null, lessonsComplete, totalLessons)
      @goHome( null, true )
    else
      new Award(language).sendAward( onConfirm, onCancel, lessonsComplete, totalLessons )

  @getLessonIndex = =>
    return @state.get "lessonIndex"

  @setLessonIndex = (index) =>
    @state.set "lessonIndex", index

  @isHomePage = =>
    return @state.get "homePage"

  @setOnHomePage = (isHomePage) =>
    @state.set "homePage", isHomePage

  @startLesson = (index) =>
    @setLessonIndex index
    @setOnHomePage false
    @initializeSwiper()
    @displayModule(0)

  @goToNextLesson = =>
    if @isLastLesson()
      @goHome(null, false)
    else
      currentLessonIndex = @getLessonIndex()
      @startLesson currentLessonIndex + 1

  @goHome = ( event, completedCurriculum) =>
    lesson = @getCurrentLesson()
    module = @getCurrentModule()
    text = if module?.title then module?.title else module?.question
    analytics.track "Left Lesson For Home", {
      lessonTitle: lesson?.title
      lessonId: lesson?._id
      lastModuleId: module?._id
      lastModuleText: text
      lastModuleType: module?.type
      completedCurriculum: completedCurriculum
      numberOfModulesInLesson: lesson?.modules.length
    }
    @incrementLevel()
    @setStateToDefault()
    @stopAudio()
    @swiper.slideTo @HOME_SLIDE_INDEX

  @incrementLevel= =>
    levels = AppState.getLevels()
    level = @getLevel()
    console.log "Incrementing the level"
    console.log level
    console.log levels
    if level == levels[0].name
      console.log "SEtting level to intermediate"
      @setLevel levels[1].name
    else if level == levels[1].name
      @setLevel levels[2].name
    else if level == levels[2].name
      @setLevel levels[0].name
    else
      console.log "Going to the default"
      @setLevel levels[0].name

  @getAudioPlaying = () =>
    return @state.get "audioPlaying"

  @setAudioPlaying = (type) =>
    @state.set "audioPlaying", type

  @displayModule = (index) =>
    @setModuleIndex index
    @setAudioPlaying "QUESTION"
    @setNextButtonAnimated false
    #@setCurrentModuleId()
    @swiper.slideTo index + 1
    module = @getCurrentModule()

    if module.type == "VIDEO"
      @playVideo module

    if @hasAudio(module)
      onFinishAudio = if module.type == "SLIDE" then @onFinishExplanation.bind(@, module) else @trackAudioStopped
      audio = @playAudio ContentInterface.getSrc(module.audio, "AUDIO"), 1, onFinishAudio, onFinishAudio
      @setCurrentAudio audio

  @stopVideo = (module) =>
    $("#" + module._id).find("video")[0]?.pause()

  @playVideo = (module) =>
    $("#" + module._id).find("video")[0]?.play()

  @initializeSwiper = =>
    @swiper = AppState.getF7().swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      speed: 700,
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

  @goToNextModule = =>
    index = @getModuleIndex()
    newIndex = ++index
    #if newIndex == 1
      #@initializeSwiper()
    @displayModule( newIndex )

  #@onNextButtonRendered = =>
    #@initializeSwiper()

  @showIntroductionToQuestions = =>
    language = AppState.getLanguage()
    onConfirm = ()=>
      @goToNextModule()
    onCancel = ()=>
    new IntroductionToQuestions().send( onConfirm, onCancel, language )

  @stopAudio = =>
    @getCurrentAudio().stop()

  @destroyAudio = =>
    for audio in @liveAudio
      audio.destroy()
    @liveAudio = []

  @onNextButtonClicked = =>
    #if @hasBonusVideo() and @secondToLastModule() then @offerBonusVideo()
    lessonComplete = @lessonComplete()
    currentModule = @getCurrentModule()
    @destroyAudio()
    #if currentModule.type == "VIDEO" and not lessonComplete
      #@stopVideo currentModule
    #else if @lessonComplete() then @celebrateCompletion() else @goToNextModule()
    if @lessonComplete() then @celebrateCompletion() else @goToNextModule()

  @goHomeButtonText = =>
    language = AppState.getLanguage()
    home = AppState.translate "home", language, "UPPER"
    return "<span class='center'>#{home}<i class='fa fa-home'></i></span>"

  @nextButtonText = =>
    language = AppState.getLanguage()
    text = if @lessonComplete() then AppState.translate( "finish", language, "UPPER") else AppState.translate( "next", language, "UPPER")
    return "<span class='center'>#{text}<i class='fa fa-arrow-right'></i></span>"

  @getCurrentAudio = =>
    return @currentAudio

  @onReplayButtonClicked = =>
    @getCurrentAudio().replay()

  @shouldShowReplayButton = =>
    module = @getCurrentModule()
    return module?.type isnt "VIDEO"

  @onVideoEnd = =>
    lessonComplete = @lessonComplete()
    if not lessonComplete and not @isHomePage()
      @showIntroductionToQuestions()

  @shouldPlayQuestionAudio = (id) =>
    isPlayingQuestion = @state.get "playingQuestion"
    return @isCurrent(id) and isPlayingQuestion

  @shouldPlayExplanationAudio = (id) =>
    shouldPlay = @state.get "playingExplanation"
    if @isCurrent(id) and shouldPlay then return true else return false

  @setNextButtonAnimated = (value) =>
    @state.set "nextButtonAnimated", value

  @getNextButtonAnimated = ()=>
    #playing = @getAudioPlaying()
    #return playing is null
    return @state.get "nextButtonAnimated"

  @hasAudio = (module)=>
    return module.audio?

  @hasExplanation = (module)=>
    return module.correct_audio?


  @autorun =>
    if Meteor.status().connected
      @subscribe "curriculums.all"
      @subscribe "lessons.all"
      @subscribe "modules.all"

  @setStateToDefault()

Template.Lesson_view_page.helpers
  modulesReady: ->
    instance = Template.instance()
    return ContentInterface.subscriptionsReady(instance)

  footerArgs: ->
    instance = Template.instance()
    language = AppState.getLanguage()
    return {
      language: language
      visible: !instance.isHomePage()
      homeButton: {
        onClick: instance.goHome
        shouldShow: true
        text: instance.goHomeButtonText()
      }
      nextButton: {
        onClick: instance.onNextButtonClicked
        text: instance.nextButtonText()
        onRendered: instance.onNextButtonRendered
        animated: instance.getNextButtonAnimated()
      }
      replayButton: {
        onClick: instance.onReplayButtonClicked
        shouldShow: instance.shouldShowReplayButton()
        text: '<span class="center"><i class="fa fa-repeat"></i></span>'
      }
      progressBar: {
        percent: instance.getProgress()
        shouldShow: true
      }
    }

  lessonTitle: ->
    instance = Template.instance()
    return instance.getCurrentLesson()?.title

  isCurrent: (module) ->
    instance = Template.instance()
    return instance.isCurrent module._id

  moduleArgs: (module) ->
    instance = Template.instance()
    language = AppState.getLanguage()
    isQuestion = (type) ->
      return type == "BINARY" or type == "SCENARIO" or type == "MULTIPLE_CHOICE"

    console.log "This is the current module!!"
    console.log module
    isCurrentModule = instance.isCurrent(module._id)
    if isQuestion module.type
      showAlert = if module.type == 'MULTIPLE_CHOICE' then false else true
      return {
        module: module
        language: language
        incorrectClasses: instance.state.get "incorrectClasses"
        incorrectlySelectedClasses: instance.state.get "incorrectlySelectedClasses"
        correctlySelectedClasses: instance.state.get "correctlySelectedClasses"
        onCorrectChoice: instance.onChoice(instance, "CORRECT", showAlert)
        onWrongChoice: instance.onChoice(instance, "WRONG", showAlert)
        onCompletedQuestion: instance.onCompletedQuestion.bind(instance, module)
      }
    else if module.type == "VIDEO"
      return {
        module: module
        language: language
        onStopVideo: instance.onVideoEnd
        onVideoEnd: instance.onVideoEnd
        isCurrent: isCurrentModule
      }
    else if module.type == "SLIDE"
      return {
        module: module
        language: language
      }

  explanationArgs: (module) ->
    instance = Template.instance()
    playing = instance.getAudioPlaying() == "EXPLANATION"
    replay = instance.state.get("replayAudio")
    isCurrent = instance.isCurrent(module._id)
    return {
      attributes: {
        src: ContentInterface.getSrc module.correct_audio, "AUDIO"
      }
      playing: playing and isCurrent
      replay: playing and replay and isCurrent
      afterReplay: instance.afterReplay
      whenFinished: instance.onFinishExplanation.bind instance, module
      whenPaused: instance.onFinishExplanation.bind instance, module
    }

  audioArgs: (module) ->
    instance = Template.instance()
    playing = instance.getAudioPlaying() == "QUESTION"
    replay = instance.state.get("replayAudio")
    isCurrent = instance.isCurrent(module._id)
    onFinishAudio = if module.type == "SLIDE" then instance.onFinishExplanation.bind(instance, module) else instance.trackAudioStopped
    return {
      attributes: {
        src: ContentInterface.getSrc module.audio, "AUDIO"
      }
      playing: playing and isCurrent
      replay: playing and replay and isCurrent
      afterReplay: instance.afterReplay
      whenFinished: onFinishAudio
      whenPaused: onFinishAudio
    }

  #incorrectSoundEffectArgs: ->
    #instance = Template.instance()
    #playing = instance.state.get("soundEffectPlaying") == "INCORRECT"
    #return {
      #attributes: {
        #src: ContentInterface.getSrc(ContentInterface.incorrectSoundEffectFilename(), "AUDIO")
      #}
      #playing: playing
      #whenFinished: instance.stopPlayingSoundEffect
      #whenPaused: instance.stopPlayingSoundEffect
    #}

  #correctSoundEffectArgs: ->
    #instance = Template.instance()
    #playing = instance.state.get("soundEffectPlaying") == "CORRECT"
    #return {
      #attributes: {
        #src: ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO")
      #}
      #playing: playing
      #whenFinished: instance.stopPlayingSoundEffect
      #whenPaused: instance.stopPlayingSoundEffect
    #}

  #stubAudioArgs: ->
    #instance = Template.instance()
    #playing = instance.state.get("playStub") == true
    #return {
      #attributes: {
        #src: ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO")
        #volume: 0
      #}
      #playing: playing
      #whenFinished: ()-> instance.setPlayStub false
      #whenPaused: ()-> instance.setPlayStub false
    #}

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

  getLanguage: ->
    return AppState.getLanguage()

  thumbnailArgs: (level ) ->
    instance = Template.instance()
    console.log "The current level!!"
    console.log instance.getLevel()
    isCurrentLevel = ( instance.getLevel() == level.name )
    return {
      level: level
      onLevelSelected: instance.onLevelSelected
      isCurrentLevel: isCurrentLevel
      language: AppState.getLanguage()
    }

  levels: ->
    return AppState.getLevels()


  homePage: ->
    instance = Template.instance()
    return instance.isHomePage()

Template.Lesson_view_page.onRendered =>
  instance = Template.instance()
  instance.playAudio ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 0
