
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ Modules } = require("meteor/noorahealth:mongo-schemas")

{ AppState } = require('../../api/AppState.coffee')
{ Level } = require('../../api/controllers/lessons/Level.coffee')
{ Award } = require('../components/lessons/popups/award.coffee')
{ Audio } = require('../components/shared/audio.coffee')
{ IntroductionToQuestions } = require('../components/lessons/popups/introduction_to_questions.coffee')
{ ContentInterface }= require('../../api/content/ContentInterface.coffee')
{ TAPi18n } = require("meteor/tap:i18n")
{ ReactiveVar } = require("meteor/reactive-var")

require './lesson_view.html'
require '../components/lessons/modules/binary.coffee'
require '../components/lessons/modules/scenario.coffee'
require '../components/lessons/modules/multiple_choice/multiple_choice.coffee'
require '../components/lessons/modules/slide.html'
require '../components/lessons/modules/video.coffee'
require '../components/lessons/levels/thumbnail.coffee'
require '../components/lessons/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->

  @state = new ReactiveDict()
  @setStateToDefault = =>
    @state.set {
      moduleIndex: 0
      correctlySelectedClasses: 'correctly-selected expanded'
      incorrectClasses: 'faded'
      incorrectlySelectedClasses: 'incorrectly-selected'
      nextButtonAnimated: false
      nextButtonAnimated: false
      lessonIndex: 0
      homePage: true
    }

  @initializeSwiper = =>
    @swiper = AppState.getF7().swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      speed: 700,
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

 ## ----------- GETTING AND SETTING STATE ---------------- ##
 
  ## 
  # LEVELS
  ##
  @levels = [
    new Level(AppState.getCurriculumDoc(), "beginner", "easy.png"),
    new Level(AppState.getCurriculumDoc(), "intermediate", "medium.png"),
    new Level(AppState.getCurriculumDoc(), "advanced", "hard.png"),
  ]

  @getLevels = =>
    return @levels

  @setLevel = (level) =>
    @state.set "level", level

  @getLevel = =>
    index = @state.get "level_index"
    return @getLevels()[index]

  ## 
  # HOME PAGE
  ##
  @isHomePage = =>
    return @state.get "homePage"

  @setOnHomePage = (isHomePage) =>
    @state.set "homePage", isHomePage
 
  @goHomeButtonText = =>
    language = AppState.getLanguage()
    home = AppState.translate "home", language, "UPPER"
    return "<span class='center'>#{home}<i class='fa fa-home'></i></span>"
  
  ##
  # FOOTER
  ##
  @setNextButtonAnimated = (value) =>
    @state.set "nextButtonAnimated", value

  @getNextButtonAnimated = ()=>
    return @state.get "nextButtonAnimated"

  @shouldShowReplayButton = =>
    module = @getCurrentModule()
    return module?.type isnt "VIDEO"

  @nextButtonText = =>
    language = AppState.getLanguage()
    text = if @lessonComplete() then AppState.translate( "finish", language, "UPPER") else AppState.translate( "next", language, "UPPER")
    return "<span class='center'>#{text}<i class='fa fa-arrow-right'></i></span>"

  ## 
  # MODULES
  ##
  @getModuleIndex = =>
    return @state.get "moduleIndex"

  @setModuleIndex = (index) =>
    @state.set "moduleIndex", index

  @getCurrentModule = =>
    index = @state.get "moduleIndex"
    return @getModules()?[index]

  @getNextModule = =>
    index = @state.get "moduleIndex"
    return @getModules()?[index + 1]

  @getModules = =>
    lesson = @getCurrentLesson()
    modules = @getCurrentLesson()?.getModulesSequence()
    return modules

  @isNext = (module) =>
    nextModule = @getNextModule()
    return module?._id is nextModule?._id

  @isCurrent = (module) =>
    currentModule = @getCurrentModule()
    return module?._id is currentModule?._id

  ## 
  # LESSONS
  ##
  @getLessonIndex = =>
    return @state.get "lessonIndex"

  @getCurrentLesson = =>
    lessonIndex = @getLessonIndex()
    return @getLessons()?[lessonIndex]

  @getLessonDocsOfLevel = (levelName) =>
    curriculum = AppState.getCurriculumDoc()
    return curriculum?.getLessonDocuments( levelName )

  @getLessons = =>
    level = @getLevel()
    return @getLessonDocsOfLevel level

  @setLessonIndex = (index) =>
    @state.set "lessonIndex", index

  @lessonComplete = =>
    index = @getModuleIndex()
    modules = @getModules()
    if modules then return index == @getModules()?.length-1 else return false

  @isLastLesson = =>
    lessonIndex = @getLessonIndex()
    return lessonIndex == @getLessons().length - 1

  @getProgress = ()=>
    numInLesson = @getModules()?.length or 0
    numCompleted = @getModuleIndex() + 1
    return (numCompleted * 100 / numInLesson).toString()
  
  ## 
  # AUDIO
  ##
  @setCurrentAudio = (audio) ->
    @currentAudio = audio
    @

  @getCurrentAudio = =>
    return @currentAudio

  @setPlayStub = (shouldPlay) ->
    @state.set "playStub", shouldPlay

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


 ## ----------------- CHANGING STATE ------------------- ##

  @incrementLevel= =>
    levels = @getLevels()
    level = @getLevel()
    if level == levels[0].name
      @setLevel levels[1].name
    else if level == levels[1].name
      @setLevel levels[2].name
    else if level == levels[2].name
      @setLevel levels[0].name
    else
      @setLevel levels[0].name

  @goToNextModule = =>
    index = @getModuleIndex()
    newIndex = ++index
    @displayModule( newIndex )

  @playAudio = (src, volume, whenFinished, whenPaused) =>
    audio = new Audio src, volume
    audio.play whenFinished, whenPaused
    @liveAudio.push audio
    return audio

  @stopAudio = =>
    @getCurrentAudio().stop()

  @destroyAudio = =>
    for audio in @liveAudio
      audio.destroy()
    @liveAudio = []

  @stopVideo = (module) =>
    $("#" + module._id).find("video")[0]?.pause()

  @playVideo = (module) =>
    $("#" + module._id).find("video")[0]?.play()

  @startLesson = (index) =>
    @setLessonIndex index
    @setOnHomePage false
    @initializeSwiper()
    @displayModule(0)

  @goToNextLesson = =>
    if @isLastLesson()
      @goHome(null, true)
    else
      currentLessonIndex = @getLessonIndex()
      @startLesson currentLessonIndex + 1
 
  @goHome = ( event, completedLevel) =>
    lesson = @getCurrentLesson()
    module = @getCurrentModule()
    text = if module?.title then module?.title else module?.question
    analytics.track "Left Lesson For Home", {
      lessonTitle: lesson?.title
      lessonId: lesson?._id
      lastModuleId: module?._id
      lastModuleText: text
      lastModuleType: module?.type
      completedLevel: completedLevel
      numberOfModulesInLesson: lesson?.modules.length
    }
    if completedLevel then @incrementLevel()
    @setStateToDefault()
    @destroyAudio()
    @swiper.slideTo @HOME_SLIDE_INDEX

  @displayModule = (index) =>
    @swiper.slideTo index + 1
    @setModuleIndex index
    @setNextButtonAnimated false
    module = @getCurrentModule()
    if module.type == "VIDEO"
      @playVideo module
    if module.hasAudio()
      onFinishAudio = if module.hasExplanation() then @trackAudioStopped else @onFinishExplanation.bind(@, module)
      audio = @playAudio ContentInterface.getSrc(module.audio, "AUDIO"), 1, onFinishAudio, onFinishAudio
      @setCurrentAudio audio

 ## ----------------- EVENTS ------------------- ##

  @onFinishExplanation = (module, pos, completed, src)=>
    currentModule = @getCurrentModule()
    if @isCurrent module
      @setNextButtonAnimated true
    @trackAudioStopped( pos, completed, src )

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

  @onCompletedQuestion = (module) ->
    @stopAudio()
    audio = @playAudio ContentInterface.getSrc(module.correct_audio, "AUDIO"), 1, @onFinishExplanation.bind(@, module), @onFinishExplanation.bind(@, module)
    @setCurrentAudio audio
    @

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

  @showIntroductionToQuestions = =>
    language = AppState.getLanguage()
    onConfirm = ()=>
      @goToNextModule()
    onCancel = ()=>
    new IntroductionToQuestions().send( onConfirm, onCancel, language )

  @onNextButtonClicked = =>
    lessonComplete = @lessonComplete()
    currentModule = @getCurrentModule()
    @destroyAudio()
    if currentModule.type == "VIDEO" and not lessonComplete
      @stopVideo currentModule
    else if @lessonComplete() then @celebrateCompletion() else @goToNextModule()

  @onReplayButtonClicked = =>
    @getCurrentAudio().replay()

  @onVideoEnd = =>
    lessonComplete = @lessonComplete()
    if not lessonComplete and not @isHomePage()
      @showIntroductionToQuestions()

  @autorun =>
    #if Meteor.status().connected
    if AppState.templateShouldSubscribe()
      @subscribe "curriculums.all"
      @subscribe "lessons.all"
      @subscribe "modules.all"

  @setStateToDefault()
  @state.set "level_index", 0
  @liveAudio = []
  @HOME_SLIDE_INDEX = 0


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

  shouldRender: (module) ->
    instance = Template.instance()
    return instance.isCurrent(module) or instance.isNext(module)

  moduleArgs: (module) ->
    instance = Template.instance()
    language = AppState.getLanguage()
    isCurrentModule = instance.isCurrent(module)
    if module.isQuestion()
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

  levelThumbnailArgs: (level ) ->
    instance = Template.instance()
    console.log "instance level"
    console.log instance.getLevel()
    console.log "This level"
    console.log level
    isCurrentLevel = instance.getLevel().isEqual(level)
    return {
      level: {
        name: level.getName()
        image: level.getImage()
      }
      onLevelSelected: instance.onLevelSelected
      isCurrentLevel: isCurrentLevel
      language: AppState.getLanguage()
    }

  levels: ->
    instance = Template.instance()
    return instance.getLevels()

  homePage: ->
    instance = Template.instance()
    return instance.isHomePage()

Template.Lesson_view_page.onRendered =>
  instance = Template.instance()
  instance.playAudio ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 0
