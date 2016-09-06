
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ OfflineFiles } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface } = require('../content/ContentInterface.coffee')
{ AppConfiguration } = require('../AppConfiguration.coffee')

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

    loadCurriculums: ( cursor, onComplete )=>
      try
        #validate the arguments
        new SimpleSchema({
          cursor: {type: Mongo.Cursor}
          onComplete: {type: Function}
        }).validate({cursor: cursor, onComplete: onComplete})

        if not Meteor.status().connected
          throw new Meteor.Error "not-connected", "The iPad is not connected to data. Please connect and try again"

        curriculums = cursor.fetch()

        images = []
        audio = []
        video = []

        audio.push ContentInterface.getDirectory( "AUDIO" ) + ContentInterface.introFilename()
        audio.push ContentInterface.getDirectory( "AUDIO" ) + ContentInterface.correctSoundEffectFilename()
        audio.push ContentInterface.getDirectory( "AUDIO" ) + ContentInterface.incorrectSoundEffectFilename()
        
        levels = AppConfiguration.getLevels()
        for level in levels
          images.push ContentInterface.getDirectory( "IMAGE" ) + level.image

        for curriculum in curriculums
          images.merge @_allContentPathsInCurriculum curriculum, "IMAGE"
          audio.merge @_allContentPathsInCurriculum curriculum, "AUDIO"
          video.merge @_allContentPathsInCurriculum curriculum, "VIDEO"

        removeAlreadyExistingPaths = ( path )->
          return not OfflineFiles.findOne {path: path}

        images = images.filter removeAlreadyExistingPaths
        video = video.filter removeAlreadyExistingPaths
        audio = audio.filter removeAlreadyExistingPaths

        @_downloadFiles([
          { paths: images, type: "IMAGE" },
          { paths: video, type: "VIDEO" },
          { paths: audio, type: "AUDIO" },
        ])
        .then ->
          onComplete null
        , (err)->
          console.log "This is the middle one"
          message = ""
          onComplete err
        , (progress) ->
          AppConfiguration.setPercentLoaded progress
      catch e
        console.log "in the on complete"
        console.log e
        onComplete e

    _downloadFiles: ( pathObjects )->
      deferred = Q.defer()
      error = null
      retry = []
      numRecieved = 0
      numToDownload = 0
      ( numToDownload += obj.paths.length for obj in pathObjects )

      if pathObjects.length == 0
        deferred.resolve(error)

      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->

        ft = new FileTransfer()

        ft.onprogress = ( event )->
          percent = numRecieved / numToDownload
          deferred.notify percent

        downloadFile = ( path, type )->
          fsPath = fs.root.toURL() + path
          src = ContentInterface.getRemoteSource(path, type.toLowerCase())
          console.log src
          ft.download( src , fsPath, onSuccess.bind( @, path, fsPath, type ), onError.bind(@, path, fsPath, type), true)

        markAsResolved = ( entry )->
          numRecieved++
          console.log "RESOLVED:" + numRecieved + "/"+ numToDownload
          if numRecieved == numToDownload
            deferred.resolve entry

        onSuccess = ( path, fsPath, type, entry )->
          id = OfflineFiles.insert {
            #url: file.url
            path: path
            fsPath: fsPath
          }
          markAsResolved()

        onError = ( path, type, err )->
          console.log "There was an error: "
          console.log err
          console.log err.code
          console.log err.code == 3
          if err.http_status == 404
            markAsResolved path
            error = new Meteor.Error("error-downloading", "Some content could not be found")
          else if err.code == 2
            markAsResolved path
            error = new Meteor.Error("error-downloading", "Error accessing content on server")
          else if err.code == 3
            if path in retry
              markAsResolved path
              # If already retried downloading, reject
              error = new Meteor.Error("error-downloading", "Timeout accessing content on server")
            else
              console.log "Retrying download"
              # Try downloading again
              retry.push path
              downloadFile path, type
          else
            markAsResolved path
            error = err

        for obj in pathObjects
          for path in obj.paths
            downloadFile path, obj.type

      , ( err )->
        # Error retrieving the local filesystem
        deferred.resolve err

      return deferred.promise
      
    _allContentPathsInCurriculum: ( curriculum, type )->
      paths = []
      lessons = curriculum.getLessonDocuments("introduction")
        .concat curriculum.getLessonDocuments("beginner")
        .concat curriculum.getLessonDocuments("intermediate")
        .concat curriculum.getLessonDocuments("advanced")
      for lesson in lessons
        switch type
          when "IMAGE"
            paths.merge @_allImagesInLesson(lesson)
          when "AUDIO"
            paths.merge @_allAudioInLesson(lesson)
          when "VIDEO"
            paths.merge @_allVideosInLesson(lesson)
      return paths

    #_allContentPathsInLesson: (lesson) ->
      #if not lesson?
        #return []

      #modules = lesson.getModulesSequence()
      #paths = []
      #if lesson.image
        #paths.push ContentInterface.getDirectory("IMAGE") + lesson.image

      #for module in modules
        #paths.merge @_allContentPathsInModule(module)

      #return paths

    _allImagesInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      paths = []
      if lesson.image
        paths.push ContentInterface.getDirectory("IMAGE") + lesson.image

      for module in modules
        paths.merge @_allImagesInModule(module)

      return paths

    _allAudioInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      paths = []
      for module in modules
        paths.merge @_allAudioInModule(module)

      return paths

    _allVideosInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      paths = []
      for module in modules
        paths.merge @_allVideosInModule(module)

      return paths

    _allImagesInModule: ( module )->
      paths = []
      if module.image
        paths.push ContentInterface.getDirectory("IMAGE") + module.image
      if module.options and module.type == 'MULTIPLE_CHOICE'
        paths.merge (ContentInterface.getDirectory("IMAGE") + option for option in module.options when option?)
      return paths

    _allVideosInModule: ( module )->
      paths = []
      if module.video
        paths.push ContentInterface.getDirectory("VIDEO") + module.video
      return paths

    _allAudioInModule: ( module )->
      paths = []
      if module.audio
        paths.push ContentInterface.getDirectory("AUDIO") + module.audio
      if module.correct_audio
        paths.push ContentInterface.getDirectory("AUDIO") + module.correct_audio
      return paths

module.exports.ContentDownloader = ContentDownloader

