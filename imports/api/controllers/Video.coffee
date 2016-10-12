

class VideoController
  constructor: ->

  getVideoElem: ( module )->
    return $("#" + module._id)

  stopVideo: ( module )->
    @getVideoElem( module ).find("video")[0]?.pause()

  playVideo: ( module )->
    @getVideoElem( module ).find("video")[0]?.play()

module.exports.VideoController = VideoController
