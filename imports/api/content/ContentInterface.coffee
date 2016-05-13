##############################################################################
#
# ContentInterface
# 
# The interface between the app and the Noora Health content (images, videos, audio).
# It knows where the Noora Health content is located and how to get there.
#
##############################################################################

{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")

class ContentInterface
  @get: ()->
    if not @interface?
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface

    constructor: ->
      @contentEndpoint = Meteor.settings.public.CONTENT_SRC

    introPath: =>
      return "AppIntro.mp3"

    correctSoundEffectFilePath: =>
      return "correct_soundeffect.mp3"

    incorrectSoundEffectFilePath: =>
      return "incorrect_soundeffect.mp3"

    # Where the content is stored remotely (AWS S3 server)
    getEndpoint: (path) =>
      if path? then return encodeURI(@contentEndpoint + path) else return encodeURI(@contentEndpoint)

    # Given a filename (path), getSrc will identify where to find
    # that particular file -- in Cordova, this is local and in the browser
    # it will find it remotely
    #getSrc: (path) =>
      #url = @getEndpoint(path)
      #if Meteor.isCordova
        #offlineFile = OfflineFiles.findOne {url: url}
        #if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      #else
        #return url

    getSrc: (path) =>
      return path

    subscriptionsReady: (instance) ->
      if Meteor.status().connected
        console.log "Connected in hom: returning ", instance.subscriptionsReady()
        return instance.subscriptionsReady()
      else if Meteor.isCordova
        console.log "not connected in cordova: returning ". AppState.get().isSubscribed()
        return AppState.get().isSubscribed()
      else
        return instance.subscriptionsReady()

module.exports.ContentInterface = ContentInterface
