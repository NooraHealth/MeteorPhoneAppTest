
##############################################################################
#
# VideoContent
# 
# The interface between the images on the remote server and the app
#
##############################################################################

{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")
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
    return cloudinary.url path, { resource_type: "video", transformation: ["iPad_video"] }

class SingletonWrapper
  @getVideoContent: ->
    @videoContent ?= new VideoContent()
    return @videoContent

module.exports.VideoContent = SingletonWrapper.getVideoContent()
