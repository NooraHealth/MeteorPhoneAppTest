
OfflineFiles = require('../cordova/offline_files.coffee').OfflineFiles
ContentDownloader = require('../cordova/ContentDownloader.coffee').ContentDownloader
Curriculums = require('../curriculums/curriculums.coffee').Curriculums

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
      if Meteor.isCordova
        offlineFile = OfflineFiles.findOne {url: url}
        if offlineFile? then WebAppLocalServer.localFileSystemUrl(offlineFile.fsPath) else ""
      else
        return @getEndpoint(path)

    incorrectSoundEffect: =>
      return @getSrc @incorrectSoundEffectFilePath

    correctSoundEffect: =>
      return @getSrc @correctSoundEffectFilePath

    introAudio: =>
      return @getSrc @introPath

    loadCurriculum: (id) =>
      console.log "ABOUT TO DOWNLOAD CURRICUM"
      if not id? then return null

      curriculum = Curriculums.findOne { _id: id }
      console.log "Curridulum?", curriculum
      console.log "Id?", id
      if not curriculum? then return null
      console.log "got the curriculums", curriculum
      lessons = curriculum.getLessonDocuments()
      paths = []

      paths.push @introPath
      paths.push @correctSoundEffectFilePath
      paths.push @incorrectSoundEffectFilePath

      for lesson in lessons
        paths.merge @_allContentPathsInLesson(lesson)

      getFileName = (path) ->
        return path.replace /[/]/g, ''

      urls = ( {url: @getEndpoint(path), name: getFileName(path)} for path in paths )

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
      return @contentEndpoint

module.exports.ContentInterface = ContentInterface
