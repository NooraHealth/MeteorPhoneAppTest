
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ BonusVideoPopup } = require('../popups/watchBonusVideo.coffee')
{ ContentInterface } = require('../../../../api/content/ContentInterface.coffee')
require "./video.html"

Template.Lesson_view_page_video.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    rendered: false
  }

  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      onPlayVideo: {type: Function, optional: true}
      onStopVideo: {type: Function, optional: true}
      onVideoEnd: {type: Function, optional: true}
      onCancel: {type: Function, optional: true}
      playing: {type: Boolean}
      isBonus: {type: Boolean}
      isCurrent: {type: Boolean}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @displayedPopup = false
  @autorun =>
    console.log "AUTORUN"
    console.log Template.currentData().isCurrent
    data = Template.currentData()
    if data.isCurrent and data.isBonus and not @displayedPopup
      @displayedPopup = true
      onConfirm = =>
        @playVideo()

      onCancel = =>
        data.onCancel()

      console.log "IS CURRENT ABOUT TO POPUUP"
      new BonusVideoPopup().display onConfirm, onCancel
      
  @onStopVideo = (location) =>
    if @data.onStopVideo
      @data.onStopVideo()

  @trackStoppedVideo = (currentTime, completed) ->
    analytics.track "Stopped Video", {
      time: currentTime
      completed: completed
      title: @data.module.title
      moduleId: @data.module._id
      src: @data.module.video
    }

  @onPlayVideo = =>
    console.log "Playing the video"
    if @data.onPlayVideo
      @data.onPlayVideo()

  @onVideoEnd = =>
    if @data.onVideoEnd
      @data.onVideoEnd()

  @elem = (template) ->
    if not @state.get("rendered") then return ""
    else
      return template.find "video"

  @autorun =>
    elemRendered = @state.get "rendered"
    if not elemRendered then return
    shouldPlay = Template.currentData().playing
    instance = @
    elem = @elem instance
    if not shouldPlay
      elem.pause()

  @playVideo = =>
    @elem(@).play()


Template.Lesson_view_page_video.helpers
  iframeAttributes: (module) ->
    return {
      title: module.title
      class: "embedded-video center"
      src: "#{module.video_url}?start=#{module.start}&end=#{module.end}"
      frameborder: "0"
      allowfullscreen: true
    }

  videoTagAttributes: (module) ->
    return {
      title: module.title
      class: "video-module center"
      src: ContentInterface.get().getSrc(module.video)
      controls: true
    }
  
  playing: ->
    console.log("Returning whether playing")
    instance = Template.instance()
    console.log instance.data.playing
    return instance.data.playing

Template.Lesson_view_page_video.events
  'touchend #play_video': ->
    instance = Template.instance()
    instance.playVideo()

Template.Lesson_view_page_video.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true

  elem = instance.elem(instance)
  elem.addEventListener "playing", ->
    instance.onPlayVideo()

  elem.addEventListener "pause", ->
    instance.onStopVideo()
    instance.trackStoppedVideo( elem.currentTime, false )

  elem.addEventListener "onended", ->
    instance.onVideoEnd()
    instance.trackStoppedVideo( elem.currentTime, true )
  
  
