
##############################################################################
#
# ImageContent
# 
# The interface between the images on the remote server and the app
#
##############################################################################

{ OfflineFiles } = require "../collections/offline_files.js"
{ ContentInterface } = require "./base/ContentInterface.coffee"

cloudinary = require("cloudinary")

class ImageContent extends ContentInterface

  constructor: ->
    super()
    @_directory = "Image/"

  getRemoteContent: ( filename )->
    new SimpleSchema({
      filename: { type: String }
    }).validate({ filename: filename })
  
    path = @getFullPath filename
    return cloudinary.url path, { resource_type: "image", transformation: ["iPad_image_medium"] }

class SingletonWrapper
  @getImageContent: ->
    @imageContent ?= new ImageContent()
    return @imageContent

module.exports.ImageContent = SingletonWrapper.getImageContent()
