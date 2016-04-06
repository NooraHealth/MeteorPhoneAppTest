
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./video.html"

Template.Lesson_view_page_video.onCreated ->
  # Data context validation
  @autorun =>
    console.log "This is the module of the video", Template.currentData().module
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

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
      src: module.videoSrc()
      controls: true
      autoplay: true
    }

Template.Lesson_view_page_video.onRendered ->
  console.log "Rendering the videoModule"
  #videoController = Scene.get().getModuleSequenceController().getCurrentController()
  #if videoController
    #videoController.playVideo()
  
