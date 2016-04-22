
Modules = require('../../../../api/modules/modules.coffee').Modules
ContentInterface = require('../../../../api/content/ContentInterface.coffee').ContentInterface
require "./video.html"

Template.Lesson_view_page_video.onCreated ->
  # Data context validation
  @autorun =>
    console.log "This is the module of the video", Template.currentData().module
    console.log "Validating video"
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())
    console.log "Done validating video"

Template.Lesson_view_page_video.helpers
  iframeAttributes: (module) ->
    console.log "Fetting the iframe attributes", module
    return {
      title: module.title
      class: "embedded-video center"
      src: "#{module.video_url}?start=#{module.start}&end=#{module.end}"
      frameborder: "0"
      allowfullscreen: true
    }

  videoTagAttributes: (module) ->
    console.log "Fetting the videoTag attributes", module
    return {
      title: module.title
      class: "video-module center"
      src: ContentInterface.get().getSrc(module.video)
      controls: true
      autoplay: true
    }

Template.Lesson_view_page_video.onRendered ->
  console.log "Rendering the videoModule"
  #videoController = Scene.get().getModuleSequenceController().getCurrentController()
  #if videoController
    #videoController.playVideo()
  
