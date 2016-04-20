
Curriculums = require('../curriculums/curriculums.coffee').Curriculums
ContentInterface = require('../content/ContentInterface.coffee').ContentInterface
OfflineFiles = require('./offline_files.coffee').OfflineFiles

Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader
  @get: ()->
    if not @interface?
      @interface = new PrivateDownloader()
    return @interface

  class PrivateDownloader
    constructor: ->

    loadCurriculum: (id, onSuccess, onError) =>
      console.log "ABOUT TO DOWNLOAD CURRICUM"
      if not id? then return null

      curriculum = Curriculums.findOne { _id: id }
      console.log "Curridulum?", curriculum
      console.log "Id?", id
      if not curriculum? then return null
      console.log "got the curriculums", curriculum
      console.log "ConetnInterface"
      console.log ContentInterface
      console.log "After content interface"
      lessons = curriculum.getLessonDocuments()
      paths = []

      paths.push ContentInterface.get().introAudio()
      paths.push ContentInterface.get().correctSoundEffect()
      paths.push ContentInterface.get().incorrectSoundEffect()

      for lesson in lessons
        paths.merge @_allContentPathsInLesson(lesson)

      getFileName = (path) ->
        return path.replace /[/]/g, ''

      urls = ( {url: ContentInterface.get().getEndpoint(path), name: getFileName(path)} for path in paths )

      promise = @_downloadFiles urls
      promise.then (entry)->
        #this is where you do the on success thing
        onSuccess(entry)
      promise.fail (err)->
        #this is where you do the on error thing
        onError(err)


    _downloadFiles: (files) ->

      new SimpleSchema({
        "files.$.name": {type: String}
        "files.$.url": {type: String}
      }).validate({files: files})

      deferred = Q.defer()
      numToLoad = files.length
      numRecieved = 0

      window.requestFileSystem LocalFileSystem.PERSISTENT, 5*1024*1024, (fs)->

        ft = new FileTransfer()

        ft.onprogress = (event)->
          percent = numRecieved/numToLoad
          Session.set "percent loaded", percent

        downloadFile = (file) ->
          offlineId = Random.id()
          console.log fs
          console.log fs.root
          console.log fs.root.nativeUrl
          console.log "After those things"
          fsPath = fs.root.toURL() + offlineId
          console.log "The fs path", fsPath
          ft.download(file.url, fsPath, getSuccessCallback(file, fsPath), getErrorCallback(file, fsPath))


        getSuccessCallback = (file, fsPath) ->
          return (entry)->
            numRecieved++
            console.log "RESOLVED:" + numRecieved + "/"+ numToLoad
            console.log entry
            OfflineFiles.insert {
              url: file.url
              name: file.name
              fsPath: fsPath
            }
            if numRecieved == numToLoad
              deferred.resolve entry

        getErrorCallback = (file) ->
          return (error)->
            console.log "ERROR "
            console.log error
            if error.http_status == 404
              markAsResolved()
            else if error.code == 3
              downloadFile file
            else
              deferred.reject(error)

        for file in files
          if not (OfflineFiles.findOne { url: file.url })?
            downloadFile file

      , (err)->
        console.log "ERROR requesting local filesystem: "
        console.log err
        promise.reject err

      return deferred.promise

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


module.exports.ContentDownloader = ContentDownloader

