
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

        paths = []
        paths.push ContentInterface.getDirectory( "AUDIO" ) + ContentInterface.introFilename()
        paths.push ContentInterface.getDirectory( "AUDIO" ) + ContentInterface.correctSoundEffectFilename()
        paths.push ContentInterface.getDirectory( "AUDIO" ) + ContentInterface.incorrectSoundEffectFilename()
        
        levels = AppState.getLevels()
        for level in levels
          paths.push ContentInterface.getDirectory( "IMAGE" ) + level.image

        for curriculum in curriculums
          paths.merge @_allContentPathsInCurriculum( curriculum )

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
          AppState.setPercentLoaded progress
      catch e
        console.log "in the on complete"
        console.log e
        onComplete e


    _downloadFiles: (paths) ->

      deferred = Q.defer()
      error = null
      #filter paths for those that do not already exist locally
      console.log "The number of paths #{paths.length}"
      toDownload = paths.filter (path)->
        return not OfflineFiles.findOne {path: path}

      console.log "The number to download #{toDownload.length}"
      if toDownload.length == 0
        deferred.resolve(error)

      retry = []
      numRecieved = 0

      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->

        ft = new FileTransfer()

        ft.onprogress = (event)->
          percent = numRecieved/toDownload.length
          deferred.notify(percent)

        downloadFile = (path) ->
          fsPath = fs.root.toURL() + path
          ft.download(ContentInterface.getRemoteSource(path), fsPath, getSuccessCallback(path, fsPath), getErrorCallback(path, fsPath), true)

        markAsResolved = (entry) ->
          numRecieved++
          console.log "RESOLVED:" + numRecieved + "/"+ toDownload.length
          if numRecieved == toDownload.length
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

        for path in toDownload
          downloadFile path

      , (err)->
        # Error retrieving the local filesystem
        deferred.resolve err

      return deferred.promise
      
    _allContentPathsInCurriculum: (curriculum) ->
      paths = []
      lessons = curriculum.getLessonDocuments("introduction")
        .concat curriculum.getLessonDocuments("beginner")
        .concat curriculum.getLessonDocuments("intermediate")
        .concat curriculum.getLessonDocuments("advanced")
      for lesson in lessons
        paths.merge @_allContentPathsInLesson(lesson)
      return paths

    _allContentPathsInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      paths = []
      if lesson.image
        paths.push ContentInterface.getDirectory("IMAGE") + lesson.image

      for module in modules
        paths.merge @_allContentPathsInModule(module)

      return paths

    _allContentPathsInModule: (module) ->
      paths = []
      if module.image
        paths.push ContentInterface.getDirectory("IMAGE") + module.image
      if module.video
        paths.push ContentInterface.getDirectory("VIDEO") + module.video
      if module.audio
        paths.push ContentInterface.getDirectory("AUDIO") + module.audio
      if module.correct_audio
        paths.push ContentInterface.getDirectory("AUDIO") + module.correct_audio
      if module.options and module.type == 'MULTIPLE_CHOICE'
        paths.merge (ContentInterface.getDirectory("IMAGE") + option for option in module.options when option?)
      return paths


module.exports.ContentDownloader = ContentDownloader

