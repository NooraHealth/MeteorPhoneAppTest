Template.videoModule.onRendered ()->
  console.log "Rendering the videoModule"
  videoController = Scene.get().getModuleSequenceController().getCurrentController()
  if videoController
    videoController.playVideo()
  
