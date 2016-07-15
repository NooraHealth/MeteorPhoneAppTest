
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
        new SimpleSchema({
          cursor: {type: Mongo.Cursor}
          onComplete: {type: Function}
        }).validate({cursor: cursor, onComplete: onComplete})

        if not Meteor.status().connected
          throw new Meteor.Error "not-connected", "The iPad is not connected to data. Please connect and try again"

        curriculums = cursor.fetch()
        console.log "Downloading these docs"
        console.log curriculums
        console.log "number of curriculums in the database"
        console.log Curriculums.find().count()

        console.log "THUJGHJRIJSDKJ--------------------------------"
        console.log " The curriculums to download"
        console.log curriculums
        paths = []
        paths.push ContentInterface.get().getDirectory( "AUDIO" ) + ContentInterface.get().introFilename()
        console.log "paths"
        console.log paths
        paths.push ContentInterface.get().getDirectory( "AUDIO" ) + ContentInterface.get().correctSoundEffectFilename()
        console.log "paths"
        console.log paths
        paths.push ContentInterface.get().getDirectory( "AUDIO" ) + ContentInterface.get().incorrectSoundEffectFilename()
        console.log "paths"
        console.log paths

        for curriculum in curriculums
          #curriculum = Curriculums.findOne { _id: docs[0]._id }
          #if Meteor.settings.public.METEOR_ENV == "development"
            #if doc.language isnt "Hindi" then continue

          #curriculum = Curriculums.findOne { _id: doc._id }
          #if not curriculum? then throw new Meteor.Error "curriculum-not-found", "Curriculum of id #{id} not found"

          console.log curriculum
          paths.merge @_allContentPathsInCurriculum( curriculum )
          console.log "PATHS TO DOWNLOAD"
          console.log paths
          console.log paths.length

        #getFileName = (path, index) ->
          #getRandomInt = (min, max) => Math.floor(Math.random() * (max - min)) + min
          #rand = getRandomInt(1, 400)
          #matches = path.match(/[\.][a-z1-9]+$/)
          #filetype = matches[ matches.length - 1 ] #the filetype extension will be the last match
          #newFilename = index + rand + filetype
          #return newFilename

        #filteredFiles = []
        #files = ({
          #path: path
          ##url: ContentInterface.get().getEndpoint(path),
          ##name: getFileName(path, index)
        #} for path, index in paths )
        #filteredFiles.push file for file in files when not OfflineFiles.findOne({url: file.url})?
        #filteredFiles.push file for file in files when not OfflineFiles.findOne({path: file.path})?

        @_downloadFiles paths
        .then (error)->
          #this is where you do the on success thing
          console.log "about to run on complete"
          console.log error
          onComplete(error)
        , (err)->
          console.log "This is the middle one"
          message = ""
        , (progress) ->
          AppState.get().setPercentLoaded progress
      catch e
        console.log "in the on complete"
        console.log e
        onComplete e


    _downloadFiles: (paths) ->

      deferred = Q.defer()
      error = null
      numToLoad = paths.length
      console.log paths
      retry = []
      numRecieved = 0
      if numToLoad == 0
        deferred.resolve(error)

      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->

        ft = new FileTransfer()

        ft.onprogress = (event)->
          percent = numRecieved/numToLoad
          deferred.notify(percent)

        downloadFile = (path) ->
          fsPath = fs.root.toURL() + path
          ft.download(ContentInterface.get().getEndpoint(path), fsPath, getSuccessCallback(path, fsPath), getErrorCallback(path, fsPath), true)

        markAsResolved = (entry) ->
          numRecieved++
          console.log "RESOLVED:" + numRecieved + "/"+ numToLoad
          if numRecieved == numToLoad
            deferred.resolve entry

        getSuccessCallback = (path, fsPath) ->
          return (entry)->
            console.log "About to insert the file"
            console.log path
            id = OfflineFiles.insert {
              #url: file.url
              path: path
              fsPath: fsPath
            }
            console.log "Successfully entered: here is the OfflineFile"
            console.log OfflineFiles.findOne({_id: id})
            markAsResolved()

        getErrorCallback = (path) ->
          return (err)->
            console.log "There was an error: "
            console.log err
            console.log err.code
            console.log err.code == 3
            if err.http_status == 404
              markAsResolved(path)
              error = new Meteor.Error("error-downloading", "Some content could not be found")
            else if err.code == 2
              markAsResolved(path)
              error = new Meteor.Error("error-downloading", "Error accessing content on server")
            else if err.code == 3
              if path in retry
                markAsResolved(path)
                # If already retried downloading, reject
                error = new Meteor.Error("error-downloading", "Timeout accessing content on server")
              else
                console.log "Retrying download"
                # Try downloading again
                retry.push path
                console.log retry
                downloadFile path
            else
              markAsResolved(path)
              error = err

        for path in paths
          if not (OfflineFiles.findOne { path: path })?
            downloadFile path

      , (err)->
        # Error retrieving the local filesystem
        deferred.resolve err

      return deferred.promise

    #cleanLocalContent: ( cursor, onComplete )->
      #console.log "About to delete unused files (cleanLocalContent)"
      #try
        ##validate the arguments
        #new SimpleSchema({
          #cursor: {type: Mongo.Cursor}
          #onComplete: {type: Function, optional: true}
        #}).validate({cursor: cursor, onComplete: onComplete})
        #unusedPaths = _getUnusedFilePaths(curriculums)
        #@_deleteFiles(filesToDelete)
      #catch e
        #console.log "Error deleting unused files"
        #console.log e

    #_getUnusedFilePaths: (curriculums)->
      #console.log("getting the unused file paths")
      #pathsInUse = []
      #for curriculum in curriculums
        #pathsInUse.merge @_allContentPathsInCurriculum(curriculum)

      #localFiles = OfflineFiles.find().fetch()
      #unused = []
      #for file in localFiles
        #console.log("file: ", file.path)
        #if not file.path in pathsInUse
          #unused.push file
      #console.log "Returning the unused: ", unused.length
      #return unused

    #_deleteFiles: (filePaths) ->
      ## This is where we will delete files
      #console.log "About to delete #{ filePaths.length } files"
      #console.log filePaths
      #window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
        #for path in filePaths
          #fs.root.getFile path, {create: false}, (entry)->
            #entry.remove ( file )->
              #console.log "File removed!#{ path }"
            #, ( error )->
              #console.log "Error removing file #{ path }"
            #, ()->
              #console.log "Attempted to remove #{ path }, file DNE"
          #, ( event )->
            #console.log "Error retrieving file"
            #console.log evt.target.error.code
      
    _allContentPathsInCurriculum: (curriculum) ->
      paths = []
      lessons = curriculum.getLessonDocuments()
      for lesson in lessons
        paths.merge @_allContentPathsInLesson(lesson)
      return paths

    _allContentPathsInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      paths = []
      if lesson.image
        paths.push ContentInterface.get().getDirectory("IMAGE") + lesson.image

      for module in modules
        paths.merge @_allContentPathsInModule(module)

      return paths

    _allContentPathsInModule: (module) ->
      paths = []
      if module.image
        paths.push ContentInterface.get().getDirectory("IMAGE") + module.image
      if module.video
        paths.push ContentInterface.get().getDirectory("VIDEO") + module.video
      if module.audio
        paths.push ContentInterface.get().getDirectory("AUDIO") + module.audio
      if module.correct_audio
        paths.push ContentInterface.get().getDirectory("AUDIO") + module.correct_audio
      if module.options and module.type == 'MULTIPLE_CHOICE'
        paths.merge (ContentInterface.get().getDirectory("IMAGE") + option for option in module.options when option?)
      return paths


module.exports.ContentDownloader = ContentDownloader

