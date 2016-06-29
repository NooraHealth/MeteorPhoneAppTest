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
      @remoteContentEndpoint = Meteor.settings.public.CONTENT_SRC

    introPath: =>
      return "NooraHealthContent/Audio/AppIntro.mp3"

    correctSoundEffectFilePath: =>
      return "NooraHealthContent/Audio/correct_soundeffect.mp3"

    incorrectSoundEffectFilePath: =>
      return "NooraHealthContent/Audio/incorrect_soundeffect.mp3"

    # Where the content is stored remotely (AWS S3 server)
    getEndpoint: (path) =>
      if path? then return encodeURI(@remoteContentEndpoint + path) else return encodeURI(@remoteContentEndpoint)

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
      #if Meteor.status().connected
        #return instance.subscriptionsReady()
      #else if Meteor.isCordova
      console.log("Are the subscriptions ready?")
      console.log(instance.subscriptionsReady())
      return instance.subscriptionsReady()
      #if Meteor.isCordova
        #return AppState.get().isSubscribed()
      #else
        #return instance.subscriptionsReady()

module.exports.ContentInterface = ContentInterface
