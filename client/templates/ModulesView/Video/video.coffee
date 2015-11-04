Template.videoModule.onRendered ()->
  #videoController = Scene.get().getModuleSequenceController().getCurrentController()
  #videoController.playVideo()
  
