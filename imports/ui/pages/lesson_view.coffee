
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')
{ Analytics } = require('../../api/analytics/Analytics.coffee')
{ LessonsPageController } = require('../../api/controllers/LessonsPage.coffee')
{ LessonsPageModel } = require '../../api/models/lessons/LessonsPage.coffee'

require './lesson_view.html'
require '../components/lessons/slides.coffee'
require '../components/lessons/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->
  @state = new ReactiveDict()
  @state.set {
    rendered: false
    controllerInitialized: false
    numSlides: 0
  }

  @initializeSwiper = =>
    ## GOTTA LEAVE THIS CONSOLE LOG IN THERE
    # Otherwise F7 errors in finding the swiper-container
    console.log $(".swiper-container")
    console.log "initializing the swiper"
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
    if @subscriptionsReady() and @state.get("rendered") == true
      @controller = new LessonsPageController( AppConfiguration.getCurriculumDoc(), AppConfiguration.getLanguage(), AppConfiguration.getCondition() )
      @model = @controller.model
      @swiper = @initializeSwiper()
      @controller.onPageRendered?()
      @state.set "controllerInitialized", true

  @onSlidesChanged = ( numSlides )->
    if numSlides != @state.get("numSlides")
      @swiper = @initializeSwiper()
      @state.set "numSlides", numSlides

  @autorun ()->
    Tracker.afterFlush =>
      console.log "LESSON PAGE afterFlush"

  @autorun =>
    if @subscriptionsReady() and Meteor.status().connected
      Analytics.clearOfflineEvents()

  @autorun =>
    if @subscriptionsReady() and @state.get("rendered") and @state.get("controllerInitialized")
      numSlides = @state.get "numSlides"
      slideIndex = @model.slideIndex()
      @swiper.slideTo slideIndex
      @controller.onSlideToNext()


Template.Lesson_view_page.helpers
  modulesReady: ->
    instance = Template.instance()
    controllerInitialized = instance.state.get "controllerInitialized"
    ready = instance.subscriptionsReady()
    return instance.subscriptionsReady() and controllerInitialized

  footerArgs: ->
    model = Template.instance().model
    controller = Template.instance().controller
    progress = ( model.getModuleIndex() + 1) / model.getCurrentModules()?.length * 100
    return {
      language: model.getLanguage()
      visible: model.footer.get "bar", "visible"
      homeButton: {
        onClick: controller.goToSelectLevelSlide.bind controller
        shouldShow: model.footer.get "homeButton", "visible"
        text: model.footer.get "homeButton", "text"
        disabled: model.footer.get "homeButton", "disabled"
      }
      nextButton: {
        onClick: controller.onNextButtonClicked.bind controller
        text: model.footer.get "nextButton", "text"
        animated: model.footer.get "nextButton", "animated"
        disabled: model.footer.get "nextButton", "disabled"
      }
      replayButton: {
        onClick: controller.onReplayButtonClicked.bind controller
        shouldShow: model.footer.get "replayButton", "visible"
        text: model.footer.get "replayButton", "text"
        disabled: model.footer.get "replayButton", "disabled"
      }
      progressBar: {
        percent: progress.toString()
        shouldShow: true
      }
    }

  lessonTitle: ->
    model = Template.instance().model
    return model?.getCurrentLesson()?.title

  moduleOptions: ->
    instance = Template.instance()
    model = Template.instance().model
    controller = Template.instance().controller
    return {
      incorrectClasses: 'faded'
      incorrectlySelectedClasses: 'incorrectly-selected'
      correctlySelectedClasses: 'correctly-selected expanded'
      onCorrectChoice: controller.onCorrectChoice.bind controller
      onWrongChoice: controller.onWrongChoice.bind controller
      onCompletedQuestion: controller.onCompletedQuestion.bind controller
      onStopVideo: controller.onVideoEnd.bind controller
      onVideoEnd: controller.onVideoEnd.bind controller
      isCurrent: model.isCurrentModule.bind model
      onSlidesChanged: instance.onSlidesChanged.bind instance
      isCurrent: model.isCurrentModule.bind model
      isNext: model.isNextModule.bind model
    }

  levelOptions: ->
    model = Template.instance().model
    controller = Template.instance().controller
    return {
      onLevelSelected: controller.onLevelSelected.bind controller
    }

  modules: ->
    model = Template.instance().model
    return model.getCurrentModules()

  getLanguage: ->
    return Template.instance().model.getLanguage()

  levels: ->
    model = Template.instance().model
    return model.getLevels().map ( level )->
      return {
        index: level.getIndex()
        name: level.getName()
        image: level.getImage()
        isCurrent:model.isCurrentLevel.bind model, level
      }

  onSelectLevelSlide: ->
    model = Template.instance().model
    return model?.onSelectLevelSlide()

Template.Lesson_view_page.onRendered =>
  instance = Template.instance()
  instance.state.set "rendered", true
