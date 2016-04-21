
OfflineFiles = require('../cordova/offline_files.coffee').OfflineFiles

class ContentInterface
  @get: ()->
    if not @interface?
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface

    constructor: ->
      @introPath = "NooraHealthContent/Audio/AppIntro.mp3"
      @correctSoundEffectFilePath = "NooraHealthContent/Audio/correct_soundeffect.mp3"
      @incorrectSoundEffectFilePath = "NooraHealthContent/Audio/incorrect_soundeffect.mp3"
      @contentEndpoint = Meteor.settings.public.CONTENT_SRC

    getEndpoint: (path) =>
      return @contentEndpoint + path

    getSrc: (path) =>
      url = @getEndpoint(path)
      if Meteor.isCordova
        offlineFile = OfflineFiles.findOne {url: url}
        console.log "Get the source?"
        console.log offlineFile
        if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      else
        return url

    incorrectSoundEffect: =>
      return @getSrc @incorrectSoundEffectFilePath

    correctSoundEffect: =>
      return @getSrc @correctSoundEffectFilePath

    introAudio: =>
      console.log "getting the instro audio"
      console.log @getSrc @introPath
      return @getSrc @introPath

    _getContentSrc: ->
      return @contentEndpoint

module.exports.ContentInterface = ContentInterface
