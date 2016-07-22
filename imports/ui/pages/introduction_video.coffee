
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface }= require('../../api/content/ContentInterface.coffee')
{ AppState }= require('../../api/AppState.coffee')

require '../components/lesson/modules/video.coffee'
require '../components/lesson/footer/footer.coffee'
require './introduction_video.html'

Template.Introduction_video_page.onCreated ()->

  console.log "INTRODUCTION VIDEO PAGE"
  @state = new ReactiveDict()
  @state.setDefault {
    playingVideo: false
    letsBeginButtonAnimated: false
  }

  @onPlayVideo = =>
    @state.set "playingVideo", true

  @onStopVideo = =>
    @state.set "playingVideo", false

  @onVideoEnd = =>
    @state.set "playingVideo", false
    @state.set "letsBeginButtonAnimated", true

  @videoPlaying = =>
    console.log "Getting whether the video is playing"
    playing = @state.get "playingVideo"
    console.log @state
    console.log playing
    console.log playing
    if playing? then return playing else return false

  @autorun =>
   if Meteor.isCordova and Meteor.status().connected
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"

Template.Introduction_video_page.helpers
  modulesReady: ->
    instance = Template.instance()
    return instance.subscriptionsReady()
  
  introModule: ->
    return AppState.get().getIntroductionModule()

  footerArgs: ->
    console.log "FOOTER ARGS"
    instance = Template.instance()
    return {
      homeButton: {
        onClick: ->
        shouldShow: -> return false
      }
      nextButton: {
        onClick: -> FlowRouter.go "home"
        text: "LETS BEGIN"
        onRendered: ->
        animated: instance.state.get("letsBeginButtonAnimated")
      }
      replayButton: {
        onClick: ->
        shouldShow: -> return false
      }
      pages: []
    }

  videoArgs: ( module ) ->
    console.log "The module"
    console.log module
    instance = Template.instance()
    console.log "Getting the template instance()"
    console.log instance
    console.log instance.onPlayVideo
    console.log instance.onStopVideo
    console.log instance.onVideoEnd
    console.log instance.videoPlaying
    console.log instance.videoPlaying()
    data = {
      module: module
      onPlayVideo: instance.onPlayVideo
      onStopVideo: instance.onStopVideo
      onVideoEnd: instance.onVideoEnd
      playing: instance.videoPlaying()
    }
    console.log data
    return data

