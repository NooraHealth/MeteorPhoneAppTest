
{ Modules } = require "../../../../api/collections/schemas/curriculums/curriculums.js"
{ VideoContent } = require('../../../../api/content/VideoContent.coffee')

require '../../../../api/utilities/global_template_helpers.coffee'
require "./video.html"

Template.Lesson_view_page_video.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    rendered: false
  }

  # Data context validation
  @autorun =>
    # schema = new SimpleSchema({
    #   module: {type: Modules._helpers}
    #   language: {type: String}
    #   onPlayVideo: {type: Function, optional: true}
    #   onStopVideo: {type: Function, optional: true}
    #   onVideoEnd: {type: Function, optional: true}
    #   onRendered: {type: Function, optional: true}
    #   #playing: {type: Boolean}
    #   isCurrent: {type: Boolean}
    # }).validate(Template.currentData())

    @data = Template.currentData()

  @displayedPopup = false

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
    if @data.onPlayVideo
      @data.onPlayVideo()

  @onVideoEnd = =>
    if @data.onVideoEnd
      @data.onVideoEnd()

  @elem = (template) ->
    if not @isRendered() then return ""
    else
      return template.find "video"

  @isRendered = =>
    return @state.get "rendered"

  @pauseVideo = =>
    @elem(@).pause()

  @playVideo = =>
    @elem(@).play()

  @autorun =>
    if not @isRendered() then return
    isCurrent = Template.currentData().isCurrent
    if not isCurrent
      @pauseVideo()

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
      src: VideoContent.getSrc module.video
      controls: true
    }

  #playing: ->
    #instance = Template.instance()
    #return instance.data.playing

Template.Lesson_view_page_video.events
  'click #play_video': ->
    instance = Template.instance()
    instance.playVideo()

Template.Lesson_view_page_video.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true

  if instance.data.onRendered
    instance.data.onRendered()

  elem = instance.elem(instance)
  elem.addEventListener "playing", ->
    instance.onPlayVideo()

  elem.addEventListener "pause", ->
    instance.onStopVideo()
    instance.trackStoppedVideo( elem.currentTime, false )

  elem.addEventListener "onended", ->
    instance.onVideoEnd()
    instance.trackStoppedVideo( elem.currentTime, true )
