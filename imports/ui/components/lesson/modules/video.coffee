
Modules = require('../../../../api/modules/modules.coffee').Modules
ContentInterface = require('../../../../api/content/ContentInterface.coffee').ContentInterface
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
      playing: {type: Boolean}
    }).validate(Template.currentData())

  @elem = (template) ->
    if not @state.get "rendered" then return ""
    else
      template.find "video"

  @autorun =>
    elemRendered = @state.get "rendered"
    if not elemRendered then return

    playing = Template.currentData().playing
    instance = @
    elem = @elem instance
    if playing
      elem.currentTime = 0
      elem.play()
    else
      elem.pause()

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

Template.Lesson_view_page_video.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true
  #videoController = Scene.get().getModuleSequenceController().getCurrentController()
  #if videoController
    #videoController.playVideo()
  
