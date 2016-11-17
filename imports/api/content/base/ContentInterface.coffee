##############################################################################
#
# ContentInterface
#
# The interface between the app and the Noora Health content (images, videos, audio).
# It knows where the Noora Health content is located and how to get there.
#
##############################################################################

{ OfflineFiles } = require "../../collections/offline_files.js"

cloudinary = require("cloudinary")

class ContentInterface
  constructor: ->
    @_directory = ""

    cloudinary.config {
      cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
      api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
      api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
    }

  getFullPath: ( filename )->
    return @_directory + filename

  #to be implemented by parent class
  getRemoteContent: ( filename )-> return ""

  getLocalContent: ( filename )->
    new SimpleSchema({
      filename: {type: String}
    }).validate({ filename: filename })

    offlineFile = OfflineFiles.findOne { filename: filename }
    return if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""

  getSrc: ( filename )->
    new SimpleSchema({
      filename: {type: String},
    }).validate({ filename: filename })

    if Meteor.isCordova
      return @getLocalContent filename
    else
      return @getRemoteContent filename

module.exports.ContentInterface = ContentInterface
