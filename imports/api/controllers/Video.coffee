

require '../content/VideoContent'

class VideoController
  constructor: ->

  getVideoElem: ( module )->
    return $("#" + module._id).find("video")[0]

  stopVideo: ( module )->
    @getVideoElem( module )?.pause()

  playVideo: ( module )->
    # VideoPlayer.play( VideoContent.getSrc module.video )
    video = @getVideoElem(module)
    video.load()
    console.log "Loading video"
    video.addEventListener("canplay", ()=>
      console.log "CAN PLAY"
      video.play()
    );
    video.addEventListener("canplaythrough", ()=>
      console.log "CAN PLAY THROUGH"
      video.play()
    );
    numLoads = 1
    # video.addEventListener("error", (e)=>
    #   console.log "ERROR LOADING"
    #   Meteor.setTimeout( ()->
    #     if( numLoads < 6 )
    #       video.load()
    #       numLoads++
    #   , 500);
    # )

module.exports.VideoController = VideoController
