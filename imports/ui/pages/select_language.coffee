
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')
{ Analytics } = require('../../api/analytics/Analytics.coffee')
{ Translator } = require('../../api/utilities/Translator.coffee')
{ Curriculums } = require("../../api/collections/schemas/curriculums/curriculums.js")
{ Modules } = require("../../api/collections/schemas/curriculums/modules.js")
{ Lessons } = require("../../api/collections/schemas/curriculums/lessons.js")

# TEMPLATE
require './select_language.html'
require '../components/lessons/footer/footer.coffee'

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
    @swiper = AppConfiguration.getF7().swiper '.swiper-container', {
      speed: 700,
      shortSwipes: false
      longSwipes: false
      followFinger: false
    }

  @onLanguageSelected = (language) =>
    analytics.track "Changed Language", {
      fromLanguage: AppConfiguration.getLanguage()
      toLanguage: language
      condition: AppConfiguration.getCondition()
    }

    AppConfiguration.setLanguage language
    @initializeSwiper()
    @setFooterVisible true
    @playIntroVideo()
    @swiper.slideNext()

  @playIntroVideo = =>
    console.log "Checking to see if can get intro module"
    if @subscriptionsReady()
      introModule = AppConfiguration.getCurriculumDoc().getIntroductionModule()
      videoElem = @.$("##{introModule?._id}")?.find("video")?[0]
      if videoElem?
        videoElem.load()
        videoElem.play()

  @setFooterVisible = =>
    @state.set "footerVisible", true

  @footerIsVisible = =>
    return @state.get "footerVisible"

  @onVideoEnd = =>
    @state.set "letsBeginButtonAnimated", true

  @autorun =>
    #if Meteor.status().connected
    if AppConfiguration.templateShouldSubscribe()
      @subscribe "curriculums.all"
      @subscribe "lessons.all"
      @subscribe "modules.all"

  @autorun =>
    console.log "NUMBER OF CURRICULUMS"
    console.log Curriculums.find({}).fetch()
    if @subscriptionsReady() and Curriculums.find({}).count() == 0
      AppConfiguration.restoreLocalCollectionsFromPersistentStorage()

  # @autorun =>
  #   if Meteor.status().connected and @subscriptionsReady()
  #     Analytics.clearOfflineEvents()

Template.Select_language_page.helpers
  modulesReady: ->
    instance = Template.instance()
    console.log "ready??"
    console.log instance.subscriptionsReady()
    return instance.subscriptionsReady()

  introModules: ->
    modules = []
    condition = AppConfiguration.getCondition()
    languages = AppConfiguration.getSupportedLanguages()
    for curriculum in Curriculums.find({ condition: condition, language: { $in: languages }}).fetch()
      introModule = curriculum.getIntroductionModule()
      if introModule then modules.push introModule
    return modules

  shouldShow: (module) ->
    curriculumDoc = AppConfiguration.getCurriculumDoc()
    introModule = curriculumDoc?.getIntroductionModule()
    return introModule?._id == module?._id

  videoArgs: ( module ) ->
    instance = Template.instance()
    language = AppConfiguration.getLanguage()
    data = {
      module: module
      language: language
      onPlayVideo: instance.onPlayVideo
      onStopVideo: instance.onVideoEnd
      onVideoEnd: instance.onVideoEnd
      onRendered: -> instance.initializeSwiper()
      isCurrent: true
    }
    return data

  menuArgs: ->
    instance = Template.instance()
    return {
      onLanguageSelected: instance.onLanguageSelected
      languages: AppConfiguration.getSupportedLanguages()
      onRendered: -> instance.initializeSwiper()
    }

  footerArgs: ->
    instance = Template.instance()
    language = AppConfiguration.getLanguage()
    begin = Translator.translate "begin", language, "UPPER"
    text = "<span class='center'>#{begin}<i class='fa fa-arrow-right'></i></span>"
    return {
      language: language
      visible: true
      homeButton: {
        onClick: ->
        shouldShow: false
        text: ""
        disabled: false
      }
      nextButton: {
        onClick: -> FlowRouter.go "lessons"
        text: text
        onRendered: ->
        animated: instance.state.get("letsBeginButtonAnimated")
        disabled: false
      }
      replayButton: {
        onClick: ->
        shouldShow: false
        text: ""
        disabled: false
      }
      progressBar: {
        percent: "0"
        shouldShow: false
      }
    }

  footerVisible: ->
    instance = Template.instance()
    return instance.footerIsVisible()
