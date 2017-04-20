
##############################################################################
#
# VideoContent
#
# The interface between the images on the remote server and the app
#
##############################################################################

{ OfflineFiles } = require "../collections/offline_files.js"
{ ContentInterface } = require "./base/ContentInterface.coffee"

cloudinary = require("cloudinary")

class VideoContent extends ContentInterface

  constructor: ->
    super()
    @_directory = "Video/"

  getRemoteContent: ( filename )->
    new SimpleSchema({
      filename: { type: String }
    }).validate({ filename: filename })

    path = @getFullPath filename
    # return cloudinary.url path, {
    #   resource_type: "video",
    #   quality: 30,
    #   width: 400,
    #   crop: "scale",
    #   video_codec: "vp8"
    #  }
    return cloudinary.url( path , {
      resource_type: "video",
      transformation: [{
        bit_rate: "967",
        quality: 36,
        # video_codec: "vp8",
        width: 400,
        crop: "scale"
        },{
          quality: 35,
          width: 400,
          crop: "scale"
        }]
      })
class SingletonWrapper
  @getVideoContent: ->
    @videoContent ?= new VideoContent()
    return @videoContent

module.exports.VideoContent = SingletonWrapper.getVideoContent()
