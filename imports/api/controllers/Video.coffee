

class VideoController
  constructor: ->

  getVideoElem: ( module )->
    return $("#" + module._id).find("video")[0]

  stopVideo: ( module )->
    @getVideoElem( module )?.pause()

  playVideo: ( module )->
    @getVideoElem( module )?.load()
    @getVideoElem( module )?.play()

module.exports.VideoController = VideoController
