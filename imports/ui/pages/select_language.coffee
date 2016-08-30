
{ AppState } = require('../../api/AppState.coffee')
{ TAPi18n } = require("meteor/tap:i18n")
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

# TEMPLATE
require './select_language.html'
require '../components/lesson/footer/footer.coffee'

# COMPONENTS
require '../../ui/components/shared/navbar.html'
require '../../ui/components/select_language/menu/menu.coffee'

Template.Select_language_page.onCreated ->
  @state = new ReactiveDict()
  @state.setDefault {
    footerVisible: false
    letsBeginButtonAnimated: false
    playingVideo: false
  }

  @initializeSwiper = =>
    @swiper = AppState.getF7().swiper '.swiper-container', {
      speed: 700,
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

  @onLanguageSelected = (language) =>
    console.log "Language selected!!"
    analytics.track "Changed Language", {
      fromLanguage: AppState.getLanguage()
      toLanguage: language
      condition: AppState.getCondition()
    }

    AppState.setLanguage language
    levels = AppState.getLevels()
    @initializeSwiper()
    @setFooterVisible true
    @playIntroVideo()
    @swiper.slideNext()

  @playIntroVideo = =>
    introModule = AppState.getCurriculumDoc().getIntroductionModule()
    @.$("##{introModule?._id}")?.find("video")?[0]?.play()

  @setFooterVisible = =>
    @state.set "footerVisible", true

  @footerIsVisible = =>
    return @state.get "footerVisible"

  @onVideoEnd = =>
    @state.set "letsBeginButtonAnimated", true

  @autorun =>
    #if Meteor.status().connected
    if AppState.templateShouldSubscribe()
      @subscribe "curriculums.all"
      @subscribe "lessons.all"
      @subscribe "modules.all"

Template.Select_language_page.helpers
  modulesReady: ->
    instance = Template.instance()
    return instance.subscriptionsReady()
  
  introModules: ->
    modules = []
    condition = AppState.getCondition()
    for curriculum in Curriculums.find({ condition: condition }).fetch()
      introModule = curriculum.getIntroductionModule()
      if introModule then modules.push introModule

    return modules

  shouldShow: (module) ->
    curriculumDoc = AppState.getCurriculumDoc()
    introModule = curriculumDoc?.getIntroductionModule()
    return introModule?._id == module?._id

  videoArgs: ( module ) ->
    instance = Template.instance()
    language = AppState.getLanguage()
    data = {
      module: module
      language: language
      onPlayVideo: instance.onPlayVideo
      onStopVideo: instance.onVideoEnd
      onVideoEnd: instance.onVideoEnd
      onRendered: -> instance.initializeSwiper()
      #playing: instance.videoPlaying()
      isCurrent: true
    }
    return data

  menuArgs: ->
    instance = Template.instance()
    return {
      onLanguageSelected: instance.onLanguageSelected
      languages: ["English", "Hindi", "Kannada"]
      onRendered: -> instance.initializeSwiper()
    }

  footerArgs: ->
    instance = Template.instance()
    language = AppState.getLanguage()
    begin = AppState.translate "begin", language, "UPPER"
    text = "<span class='center'>#{begin}<i class='fa fa-arrow-right'></i></span>"
    return {
      language: language
      visible: true
      homeButton: {
        onClick: ->
        shouldShow: false
        text: ""
      }
      nextButton: {
        onClick: -> FlowRouter.go "lessons"
        text: text
        onRendered: ->
        animated: instance.state.get("letsBeginButtonAnimated")
      }
      replayButton: {
        onClick: ->
        shouldShow: false
        text: ""
      }
      progressBar: {
        percent: "0"
        shouldShow: false
      }
    }

  footerVisible: ->
    instance = Template.instance()
    return instance.footerIsVisible()

