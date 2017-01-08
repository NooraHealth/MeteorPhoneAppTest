

class VideoController
  constructor: ->

  getVideoElem: ( module )->
    return $("#" + module._id).find("video")[0]

  stopVideo: ( module )->
    @getVideoElem( module )?.pause()

  playVideo: ( module )->
    console.log "Playing the video for module"
    console.log module
    @getVideoElem( module )?.play()

module.exports.VideoController = VideoController
