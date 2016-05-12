
### --------------------------- IMPORTS ------------------------------------- ###

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface } = require('../content/ContentInterface.coffee')
{ AppState } = require('../AppState.coffee')

### --------------------------- ARRAY CUSTOMIZATION ------------------------------------- ###

Array::merge = (other) -> Array::push.apply @, other

##
#                                                                
# ContentDownloader                                                          
#
# Given the id of a Curriculum, the CurriculumDownloader fetches all of the 
# images, audio, and videos from the remote server (ContentInterface), 
# and stores them locally on the device. A reference to each file is stored
# as an OfflineFile document upon successful download.
#
##

class @ContentDownloader
  @get: ()->
    if not @interface?
      @interface = new PrivateDownloader()
    return @interface

  class PrivateDownloader

    constructor: ->

    loadCurriculums: (cursor, onComplete) =>
      try
        #validate the arguments
        console.log "VALIDATION THE SCHEMA"
        new SimpleSchema({
          cursor: {type: Mongo.Cursor}
          onComplete: {type: Function}
        }).validate({cursor: cursor, onComplete: onComplete})
        console.log "VALIDATED"

        if not Meteor.status().connected
          throw new Meteor.Error "not-connected", "The iPad is not connected to data. Please connect and try again"

        docs = cursor.fetch()
        console.log "Downloading these docs"
        console.log docs
        console.log "number of curriculums in the database"
        console.log Curriculums.find().count()
        filteredFiles = []
        for doc in docs
          #curriculum = Curriculums.findOne { _id: docs[0]._id }
          curriculum = Curriculums.findOne { _id: doc._id }
          if not curriculum? then throw new Meteor.Error "curriculum-not-found", "Curriculum of id #{id} not found"

          lessons = curriculum.getLessonDocuments()
          paths = []
          for lesson in lessons
            paths.merge @_allContentPathsInLesson(lesson)

          getFileName = (path, index) ->
            getRandomInt = (min, max) => Math.floor(Math.random() * (max - min)) + min
            rand = getRandomInt(1, 400)
            matches = path.match(/[\.][a-z1-9]+$/)
            filetype = matches[ matches.length - 1 ] #the filetype extension will be the last match
            newFilename = index + rand + filetype
            return newFilename

          files = ( {url: ContentInterface.get().getEndpoint(path), name: getFileName(path, index)} for path, index in paths )
          filteredFiles.push file for file in files when not OfflineFiles.findOne({url: file.url})?

        @_downloadFiles filteredFiles
        .then (error)->
          #this is where you do the on success thing
          onComplete(error)
        , (err)->
          console.log "This is the middle one"
          message = ""
        , (progress) ->
          AppState.get().setPercentLoaded progress
      catch e
        onComplete e

    _downloadFiles: (files) ->

      new SimpleSchema({
        "files.$.name": {type: String}
        "files.$.url": {type: String}
      }).validate({files: files})

      deferred = Q.defer()
      error = null
      numToLoad = files.length
      console.log files
      console.log "NUM TO LOAD before", numToLoad
      retry = []
      numRecieved = 0
      if numToLoad == 0
        deferred.resolve(error)

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
          return (err)->
            console.log "There was an error: "
            console.log err
            console.log err.code
            console.log err.code == 3
            if err.http_status == 404
              markAsResolved(file)
              error = new Meteor.Error("error-downloading", "Some content could not be found")
            else if err.code == 2
              markAsResolved(file)
              error = new Meteor.Error("error-downloading", "Error accessing content on server")
            else if err.code == 3
              console.log "errcode was 3"
              if file.name in retry
                console.log "Already retried, marking as resolved"
                markAsResolved(file)
                # If already retried downloading, reject
                error = new Meteor.Error("error-downloading", "Timeout accessing content on server")
              else
                console.log "Retrying download"
                # Try downloading again
                retry.push file
                downloadFile file
            else
              console.log "in the else statement"
              markAsResolved(file)
              error = err

        for file in files
          if not (OfflineFiles.findOne { url: file.url })?
            downloadFile file

      , (err)->
        # Error retrieving the local filesystem
        deferred.resolve err

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

