
{ Modules } = require("meteor/noorahealth:mongo-schemas")
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
      onPlayVideo: {type: Function}
      onStopVideo: {type: Function}
      onVideoEnd: {type: Function}
      playing: {type: Boolean}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @onStopVideo = =>
    @data.onStopVideo()

  @onPlayVideo = =>
    @data.onPlayVideo()

  @onVideoEnd = =>
    @data.onVideoEnd()

  @elem = (template) ->
    if not @state.get("rendered") then return ""
    else
      console.log "getting the elem"
      console.log template.find "video"
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
    console.log "about to play the vide"
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
    instance = Template.instance()
    console.log "Returning whether playing"
    console.log instance.data.playing
    return instance.data.playing

Template.Lesson_view_page_video.events
  'click #play_video': ->
    instance = Template.instance()
    instance.playVideo()

Template.Lesson_view_page_video.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true

  instance.elem(instance).addEventListener "playing", ->
    console.log "Video playing!"
    instance.onPlayVideo()

  instance.elem(instance).addEventListener "pause", ->
    console.log "Video paused!"
    instance.onStopVideo()

  instance.elem(instance).addEventListener "onended", ->
    console.log "Video onended!"
    instance.onVideoEnd()
  
  
