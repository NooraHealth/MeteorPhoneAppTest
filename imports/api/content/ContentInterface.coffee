##############################################################################
#
# ContentInterface
# 
# The interface between the app and the Noora Health content (images, videos, audio).
# It knows where the Noora Health content is located and how to get there.
#
##############################################################################

{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")

{ Lessons } = require("meteor/noorahealth:mongo-schemas")

{ Modules } = require("meteor/noorahealth:mongo-schemas")

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

cloudinary = require("cloudinary")

class ContentInterface
  @get: ()->
    if not @interface?
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface

    constructor: ->
      console.log Meteor.settings.public.CLOUDINARY_NAME
      cloudinary.config {
        cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
        api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
        api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
      }
      #Template.registerHelper 'getSrc', ( filename, type )=>
        #console.log "getting the src of #{filename}"
        #if filename? and filename != ""
          #@getSrc filename, type
        #else return ""

      @remoteContentEndpoint = Meteor.settings.public.CONTENT_SRC

    _audioDirectory: ->
      #return "NooraHealthContent/Audio/"
      return "Audio/"

    _imageDirectory: ->
      #return "NooraHealthContent/Image/"
      return "Image/"

    _videoDirectory: ->
      #return "NooraHealthContent/Video/"
      return "Video/"

    introFilename: =>
      return "AppIntro.mp3"

    correctSoundEffectFilename: =>
      return "correct_soundeffect.mp3"

    incorrectSoundEffectFilename: =>
      return "incorrect_soundeffect.mp3"

    getDirectory: (type) =>
      console.log "TYPE "
      console.log type
      if type == "video"
        return @_videoDirectory()
      if type == "image"
        return @_imageDirectory()
      if type == "audio"
        return @_audioDirectory()

    # Where the content is stored remotely (AWS S3 server)
    getRemoteSource: ( path, resource_type ) =>
      new SimpleSchema({
        path: {type: String}
      }).validate({path: path})

      console.log "THE REMOTE SOURCE"
      console.log path
      console.log cloudinary.url(path)
      return cloudinary.url path, { resource_type: resource_type }
      #return cloudinary.url "testing/commons/2/26/YellowLabradorLooking_new.jpg"
      #return encodeURI(@remoteContentEndpoint + path)
    
    
    # Where the content is stored remotely (AWS S3 server)
    getLocalSource: (path) =>
      new SimpleSchema({
        path: {type: String}
      }).validate({path: path})

      offlineFile = OfflineFiles.findOne { path: path}
      return if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""

    # Given a filename (path), getSrc will identify where to find
    # that particular file -- in Cordova, this is local and in the browser
    # it will find it remotely
    getSrc: (filename, type) =>
      new SimpleSchema({
        filename: {type: String},
        type: {type: String}
      }).validate({filename: filename, type: type})

      type = type.toLowerCase()
      path = @getDirectory(type) + filename
      if Meteor.isCordova
        return @getLocalSource path
      else
        return @getRemoteSource path, type

module.exports.ContentInterface = ContentInterface.get()
