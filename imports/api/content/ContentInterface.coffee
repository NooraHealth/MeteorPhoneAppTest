
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

    getEndpoint: (path) =>
      return @contentEndpoint + path

    getSrc: (path) =>
      url = @getEndpoint(path)
      if Meteor.isCordova
        offlineFile = OfflineFiles.findOne {url: url}
        if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      else
        return url

    _getContentSrc: ->
      return @contentEndpoint

module.exports.ContentInterface = ContentInterface
