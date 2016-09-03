
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')
{ LessonsPageController } = require('../../api/controllers/LessonsPage.coffee')
{ LessonsPageModel } = require '../../api/models/lessons/LessonsPage.coffee'

require './lesson_view.html'
require '../components/lessons/modules/binary.coffee'
require '../components/lessons/modules/scenario.coffee'
require '../components/lessons/modules/multiple_choice/multiple_choice.coffee'
require '../components/lessons/modules/slide.html'
require '../components/lessons/modules/video.coffee'
require '../components/lessons/levels/thumbnail.coffee'
require '../components/lessons/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->
  @rendered = false

  @initializeSwiper = =>
    return AppConfiguration.getF7().swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      speed: 700,
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

  #subscribe to data
  @autorun =>
    if AppConfiguration.templateShouldSubscribe()
      @subscribe "curriculums.all"
      @subscribe "lessons.all"
      @subscribe "modules.all"

  #initialize the controller when the subscriptions are ready
  @autorun =>
    if @subscriptionsReady() and @rendered = true
      @controller = new LessonsPageController( AppConfiguration.getCurriculumDoc(), AppConfiguration.getLanguage(), AppConfiguration.getCondition() )
      @model = @controller.model
  
  #re-initialize the swiper when the modules change
  @autorun =>
    @modules = @model?.getCurrentModules()
    @swiper = @initializeSwiper()

  @autorun =>
    if @subscriptionsReady() and @rendered == true and @model?
      slideIndex = @model.slideIndex()
      console.log "SLIDE INDEX"
      console.log slideIndex
      @swiper ?= @initializeSwiper()
      @swiper.slideTo slideIndex

Template.Lesson_view_page.helpers
  modulesReady: ->
    instance = Template.instance()
    return instance.subscriptionsReady() and instance.model?

  footerArgs: ->
    model = Template.instance().model
    controller = Template.instance().controller
    progress = ( model.getModuleIndex() + 1) / model.getCurrentModules()?.length * 100
    return {
      language: model.getLanguage()
      visible: model.footer.get "bar", "visible"
      homeButton: {
        onClick: controller.goToSelectLevelSlide
        shouldShow: model.footer.get "homeButton", "visible"
        text: model.footer.get "homeButton", "text"
      }
      nextButton: {
        onClick: controller.onNextButtonClicked
        text: model.footer.get "nextButton", "text"
        onRendered: controller.onNextButtonRendered
        animated: model.footer.get "nextButton", "animated"
      }
      replayButton: {
        onClick: controller.onReplayButtonClicked
        shouldShow: model.footer.get "replayButton", "visible"
        text: model.footer.get "replayButton", "text"
      }
      progressBar: {
        percent: progress.toString()
        shouldShow: true
      }
    }

  lessonTitle: ->
    model = Template.instance().model
    return model?.getCurrentLesson()?.title

  shouldRender: (module) ->
    model = Template.instance().model
    isCurrent = model.isCurrentModule module
    isNext = model.isNextModule module
    return isCurrent or isNext

  moduleArgs: (module) ->
    model = Template.instance().model
    controller = Template.instance().controller
    isCurrentModule = model.isCurrentModule module
    correctlySelectedClasses = 'correctly-selected expanded'
    incorrectClasses = 'faded'
    incorrectlySelectedClasses = 'incorrectly-selected'

    if module.isQuestion()
      showAlert = if module.type == 'MULTIPLE_CHOICE' then false else true
      return {
        module: module
        language: model.getLanguage()
        incorrectClasses: incorrectClasses
        incorrectlySelectedClasses: incorrectlySelectedClasses
        correctlySelectedClasses: correctlySelectedClasses
        onCorrectChoice: controller.onChoice(controller, "CORRECT", showAlert)
        onWrongChoice: controller.onChoice(controller, "WRONG", showAlert)
        onCompletedQuestion: controller.onCompletedQuestion.bind(controller, module)
      }
    else if module.type == "VIDEO"
      return {
        module: module
        language: model.getLanguage()
        onStopVideo: controller.onVideoEnd
        onVideoEnd: controller.onVideoEnd
        isCurrent: isCurrentModule
      }
    else if module.type == "SLIDE"
      return {
        module: module
        language: model.getLanguage()
      }

  modules: ->
    model = Template.instance().model
    return model.getCurrentModules()

  getTemplate: ( module )->
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
    return Template.instance().model.getLanguage()

  levelThumbnailArgs: ( level )->
    model = Template.instance().model
    controller = Template.instance().controller
    return {
      level: {
        index: level.getIndex()
        name: level.getName()
        image: level.getImage()
      }
      onLevelSelected: controller.onLevelSelected
      isCurrentLevel: model.isCurrentLevel level
      language: model.getLanguage()
    }

  levels: ->
    model = Template.instance().model
    return model.getLevels()

  selectLevelSlide: ->
    model = Template.instance().model
    return model?.onSelectLevelSlide()

Template.Lesson_view_page.onRendered =>
  instance = Template.instance()
  instance.rendered = true
  #instance.playAudio ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 0
