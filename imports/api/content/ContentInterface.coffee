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
{ AppState } = require("../AppState.coffee")

class ContentInterface
  @get: ()->
    if not @interface?
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface

    constructor: ->
      #Template.registerHelper 'getSrc', ( filename, type )=>
        #console.log "getting the src of #{filename}"
        #if filename? and filename != ""
          #@getSrc filename, type
        #else return ""

      @remoteContentEndpoint = Meteor.settings.public.CONTENT_SRC

    _audioDirectory: ->
      return "NooraHealthContent/Audio/"

    _imageDirectory: ->
      return "NooraHealthContent/Image/"

    _videoDirectory: ->
      return "NooraHealthContent/Video/"

    introFilename: =>
      return "AppIntro.mp3"

    correctSoundEffectFilename: =>
      return "correct_soundeffect.mp3"

    incorrectSoundEffectFilename: =>
      return "incorrect_soundeffect.mp3"

    getDirectory: (type) =>
      if type == "VIDEO"
        return @_videoDirectory()
      if type == "IMAGE"
        return @_imageDirectory()
      if type == "AUDIO"
        return @_audioDirectory()

    # Where the content is stored remotely (AWS S3 server)
    getRemoteSource: (path) =>
      new SimpleSchema({
        path: {type: String}
      }).validate({path: path})

      return encodeURI(@remoteContentEndpoint + path)
    
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
      #url = @getEndpoint(path)
      path = @getDirectory(type) + filename
      if Meteor.isCordova
        return @getLocalSource path
      else
        return @getRemoteSource path

module.exports.ContentInterface = ContentInterface.get()
