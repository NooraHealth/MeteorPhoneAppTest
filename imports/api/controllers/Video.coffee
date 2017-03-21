

class VideoController
  constructor: ->

  getVideoElem: ( module )->
    return $("#" + module._id).find("video")[0]

  stopVideo: ( module )->
    @getVideoElem( module )?.pause()

  playVideo: ( module )->
    video = @getVideoElem(module)
    video.load()
    video.addEventListener("canplay", ()=> video.play());
    numLoads = 1
    video.addEventListener("error", (e)=>
      console.log "Error loading"
      console.log e
      #try again
      if( numLoads < 4 )
        video.load()
        numLoads++
      # swal({ title: "Error Loading Video", text: e.message })
    )

module.exports.VideoController = VideoController
