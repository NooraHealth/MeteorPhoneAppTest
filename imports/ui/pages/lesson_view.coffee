
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')
{ LessonsPageController } = require('../../api/controllers/LessonsPage.coffee')
{ LessonsPageModel } = require '../../api/models/lessons/LessonsPage.coffee'

require './lesson_view.html'
require '../components/lessons/slides.coffee'
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
    if @subscriptionsReady() and @rendered == true
      @controller = new LessonsPageController( AppConfiguration.getCurriculumDoc(), AppConfiguration.getLanguage(), AppConfiguration.getCondition() )
      @model = @controller.model
  
  #re-initialize the swiper when the modules change
  @slideIndex = new ReactiveVar()

  @autorun =>
    if @subscriptionsReady() and @rendered == true and @model?
      console.log "setting the sklide index"
      #@slideIndex.set(@model.slideIndex())
      slideIndex = @model.slideIndex()
      #Tracker.afterFlush =>
      
  @onModulesRendered = ->
    console.log "in after flush"
    console.log "Teh slide index #{slideIndex}"
    console.log @model
    console.log @model.slideIndex()
    slideIndex = @model.slideIndex()
    @swiper = @initializeSwiper()
    console.log @swiper.slides
    @swiper.slideTo slideIndex

  #@autorun =>
    #console.log
    #if @subscriptionsReady() and @rendered == true and @model?

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
      onRendered: instance.onModulesRendered.bind instance
    }

  levelOptions: ->
    model = Template.instance().model
    controller = Template.instance().controller
    return {
      onLevelSelected: controller.onLevelSelected.bind controller
    }

  modules: ->
    console.log "the modules are different"
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

  selectLevelSlide: ->
    model = Template.instance().model
    return model?.onSelectLevelSlide()

Template.Lesson_view_page.onRendered =>
  instance = Template.instance()
  instance.rendered = true
  #instance.playAudio ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 0
