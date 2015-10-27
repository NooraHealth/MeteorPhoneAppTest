
class @VideoController
  constructor: ( @_module )->

  moveOnstage: ()->
    console.log "Moving the video onstage"

  moveOffstage: ()=>
    video = @.getVideoElem()
    if video and video.pause
      video.pause()
    else if video and video.pauseVideo
      video.pauseVideo()

