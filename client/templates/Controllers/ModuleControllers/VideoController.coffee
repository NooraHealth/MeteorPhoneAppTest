
class @VideoController
  constructor: ( @_module )->

  getVideoElem: ()->
    return $("#video" + @._module._id)[0]

  begin: ()->
    console.log "Moving the video onstage"
    ModulesController.stopShakingNextButton()

  #playVideo: ()->
    video = @.getVideoElem()
    if video and video.play
      video.currentTime = 0
      video.play()

    video.addEventListener "ended", ModulesController.shakeNextButton

  end: ()=>
    video = @.getVideoElem()
    if video and video.pause
      video.pause()
    else if video and video.pauseVideo
      video.pauseVideo()

