Template.videoModule.onRendered ()->
  videoController = Scene.get().getModuleSequenceController().getCurrentController()
  if videoController
    videoController.playVideo()
  
