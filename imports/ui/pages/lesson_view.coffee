
AppState = require('../../api/AppState.coffee').AppState
Lessons = require('../../api/lessons/lessons.coffee').Lessons
Modules = require('../../api/modules/modules.coffee').Modules
Award = require('../components/lesson/awards/award.coffee').Award

require './lesson_view.html'
require '../components/lesson/modules/binary.coffee'
require '../components/lesson/modules/scenario.coffee'
require '../components/lesson/modules/multiple_choice/multiple_choice.coffee'
require '../components/lesson/modules/slide.html'
require '../components/lesson/modules/video.coffee'
require '../components/lesson/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->

  @setCurrentModuleId = =>
    index = @state.get "moduleIndex"
    console.log @getLesson()
    moduleId = @getLesson()?.modules[index]._id
    console.log "setting the current moduleId", index
    console.log moduleId
    @state.set "currentModuleId", moduleId

  @isCurrent = (moduleId) =>
    current = @state.get "currentModuleId"
    console.log moduleId + " " + current
    console.log "Is current?", current is moduleId
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

  @onFinishExplanation = =>
    return =>
      #console.log "Audio finished, animate next button"
      #console.trace()
      #@state.set "playingExplanation", false

  @onAnswerCallback = (instance, type) ->
    return (module) ->
      console.log "SETTING PLAYING EXPLANATION TO TRUE"
      instance.state.set "playingExplanation", true
      if module.type is "BINARY" or module.type is "SCENARIO"
        if type is "CORRECT"
          alertType = "success"
        else
          alertType = "error"
        swal {
          title: ""
          type: alertType
          timer: 3000
        }

  @lessonComplete = =>
    lesson = @getLesson()
    index = @state.get "moduleIndex"
    return index == lesson?.modules?.length-1

  @getModules = =>
    console.log "getting the modules"
    console.log "Lesson", @getLesson()
    console.log @getLesson()?.getModulesSequence()
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
    @state.set "currentModuleId", @getLesson()?.modules[newIndex]._id

  @onNextButtonRendered = =>
    mySwiper = App.swiper '.swiper-container', {
        lazyLoading: true,
        preloadImages: false,
        nextButton: '.swiper-button-next',
    }
  
  @shouldPlayQuestionAudio = (id) =>
    isPlayingExplanation = @state.get "playingExplanation"
    if @isCurrent id then console.log "Is playing explanationin playQuestion audio?", isPlayingExplanation
    console.log @isCurrent(id) and not isPlayingExplanation
    return @isCurrent(id) and not isPlayingExplanation

  @shouldPlayExplanationAudio = (id) =>
    shouldPlay = @state.get "playingExplanation"
    if @isCurrent id then console.log "Should play the explanation audio?", shouldPlay
    if @isCurrent(id) and shouldPlay
      console.log "Returning that hsould play explanation audio!"
      return true
    else
      return false

  #subscription
  @autorun =>
    lessonId = @getLessonId()
    @subscribe "lesson", lessonId
    @subscribe "modules.inLesson", lessonId

  @state = new ReactiveDict()
  @state.setDefault {
    moduleIndex: 0
    currentModuleId: null
    correctlySelectedClasses: 'correctly-selected expanded'
    incorrectClasses: 'faded'
    incorrectlySelectedClasses: 'incorrectly-selected'
    playingExplanation: false
  }

  @setCurrentModuleId()
  


Template.Lesson_view_page.helpers
  footerArgs: ->
    instance = Template.instance()
    onNextButtonClicked = if instance.lessonComplete() then instance.celebrateCompletion else instance.goToNextModule
    return {
      onHomeButtonClicked: instance.goHome
      onNextButtonClicked: onNextButtonClicked
      onReplayButtonClicked: =>
      pages: instance.getPagesForPaginator()
      lessonComplete: instance.lessonComplete
      onNextButtonRendered: instance.onNextButtonRendered
    }

  lessonTitle: ->
    instance = Template.instance()
    return instance.getLesson()?.title

  moduleArgs: (module) ->
    instance = Template.instance()
    isQuestion = (type) ->
      return type == "BINARY" or type == "SCENARIO" or type == "MULTIPLE_CHOICE"

    if isQuestion module.type
      return {
        module: module
        incorrectClasses: instance.state.get "incorrectClasses"
        incorrectlySelectedClasses: instance.state.get "incorrectlySelectedClasses"
        correctlySelectedClasses: instance.state.get "correctlySelectedClasses"
        onCorrectAnswer: instance.onAnswerCallback(instance, "CORRECT")
        onWrongAnswer: instance.onAnswerCallback(instance, "WRONG")
        playQuestionAudio: instance.shouldPlayQuestionAudio(module._id)
        playExplanationAudio: instance.shouldPlayExplanationAudio(module._id)
        onFinishExplanation: instance.onFinishExplanation()
      }
    else
      return {module: module}

  modulesReady: ->
    instance = Template.instance()
    console.log "modules ready?", instance.subscriptionsReady()
    return instance.subscriptionsReady()

  modules: ->
    instance = Template.instance()
    console.log "Getting the modules", instance.getModules()
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
