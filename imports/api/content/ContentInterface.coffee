##############################################################################
#
# ContentInterface
# 
# The interface between the app and the Noora Health content (images, videos, audio).
# It knows where the Noora Health content is located and how to get there.
#
##############################################################################

{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")
{ AppState } = require("../AppState.coffee")

class ContentInterface
  @get: ()->
    if not @interface?
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface

    constructor: ->
      @remoteContentEndpoint = Meteor.settings.public.CONTENT_SRC
      @localAudioEndpoint = "application/app/"

    #introPath: =>
      #return @localAudioEndpoint + "AppIntro.mp3"

    introPath: =>
      return "AppIntro.mp3"

    correctSoundEffectFilePath: =>
      #return @localAudioEndpoint + "correct_soundeffect.mp3"
      return "correct_soundeffect.mp3"

    incorrectSoundEffectFilePath: =>
      return @localAudioEndpoint + "incorrect_soundeffect.mp3"

    # Where the content is stored remotely (AWS S3 server)
    getEndpoint: (path) =>
      if path? then return encodeURI(@remoteContentEndpoint + path) else return encodeURI(@remoteContentEndpoint)

    # Given a filename (path), getSrc will identify where to find
    # that particular file -- in Cordova, this is local and in the browser
    # it will find it remotely
    getSrc: (path) =>
      url = @getEndpoint(path)
      if Meteor.isCordova
        offlineFile = OfflineFiles.findOne {url: url}
        if path[path.length - 1] == "4"
          return if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
        else
          return @correctSoundEffectFilePath()
        #if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
        #if offlineFile? then offlineFile.fsPath else ""
      else
        return url

    subscriptionsReady: (instance) ->
      console.log Meteor.status()
      console.log Meteor.status().connected
      console.log Meteor.isCordova
      if Meteor.status().connected
        console.log "Connected in hom: returning ", instance.subscriptionsReady()
        return instance.subscriptionsReady()
      else if Meteor.isCordova
        console.log "Not connected in Cordova"
        console.log "AppState"
        console.log AppState
        console.log "AppState.get()"
        console.log AppState.get()
        console.log "is subscribed"
        console.log AppState.get().isSubscribed()
        console.log "not connected in cordova: returning ", AppState.get().isSubscribed()
        return AppState.get().isSubscribed()
      else
        return instance.subscriptionsReady()

module.exports.ContentInterface = ContentInterface
