###
# ContentInterface
# 
# The interface between the app and the Noora Health content (images, videos, audio).
# It knows where the Noora Health content is located and how to get there.
#
###

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
      return @contentEndpoint + path

    # Where the app should source it's content
    # If in the browser, remotely, if in Cordova, then 
    # locally
    getSrc: (path) =>
      url = @getEndpoint(path)
      if Meteor.isCordova
        offlineFile = OfflineFiles.findOne {url: url}
        if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      else
        return url

module.exports.ContentInterface = ContentInterface
