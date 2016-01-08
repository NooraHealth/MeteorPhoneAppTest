
class @VideoController
  constructor: ( @_module )->

  replay: ()->
    @.getVideoElem().pause()
    @.playVideo()

  getVideoElem: ()->
    return $("#video" + @._module._id)[0]

  begin: ()->

  playVideo: ()->
    video = @.getVideoElem()
    if video and video.play
      video.currentTime = 0
      video.play()

    video.addEventListener "ended", ()->
      console.log "ENDER 1"
      ModulesController.readyForNextModule()

  pauseVideo: ()->
    video = @.getVideoElem()
    if video and video.pause
      video.pause()
    else if video and video.pauseVideo
      video.pauseVideo()

  end: ()=>
    @.pauseVideo()

