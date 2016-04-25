
Curriculums = require('../curriculums/curriculums.coffee').Curriculums
ContentInterface = require('../content/ContentInterface.coffee').ContentInterface
AppState = require('../AppState.coffee').AppState
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
      try
        #validate the arguments
        new SimpleSchema({
          id: {type: String}
          onSuccess: {type: Function}
          onError: {type: Function, optional: true}
        }).validate({id: id, onSuccess: onSuccess, onError: onError})

        curriculum = Curriculums.findOne { _id: id }
        if not curriculum? then throw new Meteor.Error "curriculum-not-found", "Curriculum of id #{id} not found"

        lessons = curriculum.getLessonDocuments()

        paths = []
        for lesson in lessons
          paths.merge @_allContentPathsInLesson(lesson)

        getFileName = (path) ->
          spaces = new RegExp("[ ]+","g")
          backslash = new RegExp("[/]+","g")
          path = path.replace spaces, ""
          path = path.replace backslash, ""
          return path

        urls = ( {url: ContentInterface.get().getEndpoint(path), name: getFileName(path)} for path in paths )
        filteredUrls = ( url for url in urls when not OfflineFiles.findOne({url: url.url})? )

        console.log "DOWNLOADING FILTERED URLS", filteredUrls.length
        @_downloadFiles filteredUrls
        .then (entry, error)->
          #this is where you do the on success thing
          console.log "in the onsuccess"
          console.log "entry"
          console.log entry
          console.log "error"
          console.log error
          onSuccess(entry)
        , (err)->
          #this is where you do the on error thing
          console.log "throwing meteor error"
          console.log "IN THE ONCATCH"
          message = ""
          if err.code == 2
            message = "Error accessing content on server"
            onError(new Meteor.Error("error-downloading", message))
        , (progress) ->
          console.log "PROGRESS IN .notify"
          console.log progress
          AppState.get().setPercentLoaded progress
      catch e
        console.log "CATCHING THE ERROR"
        onError e

    _downloadFiles: (files) ->

      new SimpleSchema({
        "files.$.name": {type: String}
        "files.$.url": {type: String}
      }).validate({files: files})

      deferred = Q.defer()
      numToLoad = files.length
      console.log files
      console.log "NUM TO LOAD before", numToLoad
      retry = []
      numRecieved = 0
      if numToLoad == 0
        console.log "NUM TO LOAD IS 0 so resolving"
        deferred.resolve()

      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->

        ft = new FileTransfer()

        ft.onprogress = (event)->
          percent = numRecieved/numToLoad
          deferred.notify(percent)

        downloadFile = (file) ->
          offlineId = Random.id()
          fsPath = fs.root.toURL() + offlineId + file.name
          ft.download(file.url, fsPath, getSuccessCallback(file, fsPath), getErrorCallback(file, fsPath), true)


        markAsResolved = (entry) ->
          numRecieved++
          console.log "RESOLVED:" + numRecieved + "/"+ numToLoad
          if numRecieved == numToLoad
            console.log "THE NUMBERS EQUAL EACH OTHER ABOUT TO RESOLVE---------------------------"
            deferred.resolve entry

        getSuccessCallback = (file, fsPath) ->
          return (entry)->
            console.log file
            console.log entry
            OfflineFiles.insert {
              url: file.url
              name: file.name
              fsPath: fsPath
            }
            markAsResolved()

        getErrorCallback = (file) ->
          return (error)->
            if error.http_status == 404
              markAsResolved()
            else if error.code == 3
              console.log "ERROR CODE 3 about to dowload again"
              if file.name in retry
                deferred.reject error
              else
                retry.push file
                downloadFile file
            else
              console.log "ABOUT TO REJECT"
              deferred.reject error
              #throw new Meteor.Error "error-downloading", error

        for file in files
          if not (OfflineFiles.findOne { url: file.url })?
            downloadFile file

      , (err)->
        console.log "ERROR requesting local filesystem: "
        console.log err
        deferred.reject err

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

