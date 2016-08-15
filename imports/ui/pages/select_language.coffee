
{ AppState } = require('../../api/AppState.coffee')
{ TAPi18n } = require("meteor/tap:i18n")

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
    console.log "initializing the swiper in the onRendered"
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
    #FlowRouter.go "introduction"
    levels = AppState.getLevels()
    @initializeSwiper()
    @setFooterVisible true
    @playIntroVideo()
    AppState.setLevel levels[0].name
    @swiper.slideNext()

  @playIntroVideo = =>
    $("video")[0]?.play()

  @setFooterVisible = =>
    @state.set "footerVisible", true

  @footerIsVisible = =>
    return @state.get "footerVisible"

  @onVideoEnd = =>
    @state.set "letsBeginButtonAnimated", true

  @autorun =>
    if Meteor.status().connected
      @subscribe "curriculums.all"
      @subscribe "lessons.all"
      @subscribe "modules.all"

Template.Select_language_page.helpers
  modulesReady: ->
    instance = Template.instance()
    return instance.subscriptionsReady()
  
  introModule: ->
    return AppState.getIntroductionModule()

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
    console.log "Getting the menu args!!"
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
        onClick: -> FlowRouter.go "home"
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

