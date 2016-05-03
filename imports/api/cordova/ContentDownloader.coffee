
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface } = require('../content/ContentInterface.coffee')
{ AppState } = require('../AppState.coffee')

Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader
  @get: ()->
    if not @interface?
      @interface = new PrivateDownloader()
    return @interface

  class PrivateDownloader
    constructor: ->

    loadCurriculum: (id, onSuccess, onError) =>
      console.log "LOADING CURRICULM"
      try
        #validate the arguments
        console.log "VALIDATION THE SCHEMA"
        new SimpleSchema({
          id: {type: String}
          onSuccess: {type: Function}
          onError: {type: Function, optional: true}
        }).validate({id: id, onSuccess: onSuccess, onError: onError})
        console.log "VALIDATED"

        if not Meteor.status().connected
          throw new Meteor.Error "not-connected", "The iPad is not connected to data. Please connect and try again"

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
          onSuccess(entry)
        , (err)->
          #this is where you do the on error thing
          console.log "IN THE SECOND STEP"
          console.log err
          message = ""
        , (progress) ->
          AppState.get().setPercentLoaded progress
      catch e
        console.log "CATCHING THE ERROR"
        console.log e
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
            console.log "There was an error: "
            console.log error
            if error.http_status == 404
              markAsResolved()
            else if error.code == 2
              message = "Error accessing content on server"
              deferred.reject(new Meteor.Error("error-downloading", message))
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
      console.log "GETTING ALL CONTENT PATHS IN LESSOn"
      console.log lesson
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      console.log "GOT MODULES"
      console.log modules
      paths = []
      if lesson.image
        paths.push lesson.image

      for module in modules
        paths.merge @_allContentPathsInModule(module)

      console.log "Got all the paths in the lesson"
      console.log paths
      return paths

    _allContentPathsInModule: (module) ->
      console.log "GETTING ALL THE CONTENT PATHS IN THE MODULE"
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
      console.log "COMPLETE"
      return paths


module.exports.ContentDownloader = ContentDownloader

