
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./video.html"

Template.Lesson_view_page_video.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

Template.Lesson_view_page_video.onRendered ->
  console.log "Rendering the videoModule"
  #videoController = Scene.get().getModuleSequenceController().getCurrentController()
  #if videoController
    #videoController.playVideo()
  
