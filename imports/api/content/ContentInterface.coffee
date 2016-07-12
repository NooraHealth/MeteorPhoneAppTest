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
      @audioDirectory = "NooraHealthContent/Audio/"
      @imageDirectory = "NooraHealthContent/Image/"
      @videoDirectory = "NooraHealthContent/Video/"
      @remoteContentEndpoint = Meteor.settings.public.CONTENT_SRC

    introPath: =>
      return @audioDirectory + "AppIntro.mp3"

    correctSoundEffectFilePath: =>
      return @audioDirectory + "correct_soundeffect.mp3"

    incorrectSoundEffectFilePath: =>
      return @audioDirectory + "incorrect_soundeffect.mp3"

    getDirectory: ( type )=>
      if type == "VIDEO"
        return @videoDirectory
      if type == "IMAGE"
        return @imageDirectory
      if type == "AUDIO"
        return @audioDirectory
 
    # Where the content is stored remotely (AWS S3 server)
    getEndpoint: (path, type) =>
      regEx = /^(VIDEO|IMAGE|AUDIO)$/
      new SimpleSchema({
        path: {type: String}
        type: {type: String, allowedValues: ["VIDEO", "AUDIO", "IMAGE"]}
      }).validate({path: path, type: type})

      if path? then return encodeURI(@remoteContentEndpoint + @getDirectory(type) + path) else return encodeURI(@remoteContentEndpoint)

    # Given a filename (path), getSrc will identify where to find
    # that particular file -- in Cordova, this is local and in the browser
    # it will find it remotely
    getSrc: (path) =>
      #url = @getEndpoint(path)
      if Meteor.isCordova
        offlineFile = OfflineFiles.findOne {path: path}
        return if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      else
        return url

    subscriptionsReady: (instance) ->
      return instance.subscriptionsReady()

module.exports.ContentInterface = ContentInterface
