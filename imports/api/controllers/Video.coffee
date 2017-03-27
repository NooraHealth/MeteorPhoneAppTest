

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
      Meteor.setTimeout( ()->
        if( numLoads < 6 )
          video.load()
          numLoads++
      , 500);
    )

module.exports.VideoController = VideoController
