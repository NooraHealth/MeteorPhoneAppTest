

class VideoController
  constructor: ->

  stopVideo: ( module )->
    $("#" + module._id).find("video")[0]?.pause()

  playVideo: ( module )->
    $("#" + module._id).find("video")[0]?.play()

module.exports.VideoController = VideoController
