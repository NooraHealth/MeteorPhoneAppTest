
class @VideoController
  constructor: ( @_module )->

  getVideoElem: ()->

    return $("#" + @._module._id).find "video"

  begin: ()->
    console.log "Moving the video onstage"
    ModulesController.stopShakingNextButton()

  end: ()=>
    video = @.getVideoElem()
    if video and video.pause
      video.pause()
    else if video and video.pauseVideo
      video.pauseVideo()

