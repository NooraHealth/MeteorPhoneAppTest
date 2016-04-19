
OfflineFiles = require('../cordova/offline_files.coffee').OfflineFiles
ContentDownloader = require('../cordova/ContentDownloader.coffee').ContentDownloader

class ContentInterface
  @get: ()->
    if !@interface
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface


    constructor: ->
      @introPath = "NooraHealthContent/Audio/AppIntro.mp3"
      @correctSoundEffectFilePath = "NooraHealthContent/Audio/correct_soundeffect.mp3"
      @incorrectSoundEffectFilePath = "NooraHealthContent/Audio/incorrect_soundeffect.mp3"
      @contentEndpoint = Meteor.settings.public.CONTENT_SRC

    getUrl: (path) =>
      console.log "In get url"
      url = @_getContentSrc() + path
      if Meteor.isCordova
        console.log "this is the path", path
        offlineFile = OfflineFiles.findOne {url: url}
        if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      else
        return url

    incorrectSoundEffect: =>
      return @getUrl @incorrectSoundEffectFilePath

    correctSoundEffect: =>
      return @getUrl @correctSoundEffectFilePath

    introAudio: =>
      return @getUrl @introPath

    loadCurriculum: (_id) =>
      console.log "ABOUT TO DOWNLOAD CURRICUM"
      if not _id?
        return null

      curriculum = Curriculums.findOne { _id: id }
      lessons = curriculum.getLessonDocuments()
      paths = []

      paths.push @introPath
      paths.push @correctSoundEffectFilePath
      paths.push @incorrectSoundEffectFilePath

      for lesson in lessons
        paths.merge @_allContentPathsInLesson(lesson)

      getFileName = (path) ->
        console.log "GETTing the file name"
        console.log path
        console.log path.replace /\//, ''
        return path.replace /\//, ''

      urls = ( {url: @getUrl(path), name: getFileName(path)} for path in paths )

      console.log "The urls", urls
      promise = ContentDownloader.downloadFiles urls
      promise.then (entry)->
        #this is where you do the on success thing
        onSuccess(entry)
      promise.fail (err)->
        #this is where you do the on error thing
        onError(err)

    _allContentPathsInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      paths = []
      if lesson.image
        paths.push lesson.image

      for module in modules
        paths.merge @_allContentPathsInModule(module)

      return paths

    _allContentPathsInModule: (module) ->
      paths = []
      console.log module
      if module.image
        paths.push module.image
      if module.video
        paths.push module.video
      if module.audio
        paths.push module.audio
      if module.incorrect_audio
        paths.push module.incorrect_audio
      if module.correct_audio
        paths.push module.correct_audio
      if module.options and module.type == 'MULTIPLE_CHOICE'
        paths.merge (option for option in module.options when option?)
      return paths

    _getContentSrc: ->
      if Meteor.isCordova
        'http://127.0.0.1:8080/'
      else
        return @contentEndpoint

module.exports.ContentInterface = ContentInterface
