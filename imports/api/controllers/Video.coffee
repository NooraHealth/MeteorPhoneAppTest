

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

  cleanup: ->
    console.log "Cleaning up!!"
    console.log $("video")
    videos = $("video")
    for video in videos
      video.remove()
      video.src = ""
      video.load()



module.exports.VideoController = VideoController
