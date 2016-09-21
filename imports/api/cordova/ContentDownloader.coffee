
{ Curriculums } = require "meteor/noorahealth:mongo-schemas"
{ OfflineFiles } = require "meteor/noorahealth:mongo-schemas"
{ AudioContent } = require '../content/AudioContent.coffee'
{ correctSoundEffectFilename } = require '../content/AudioContent.coffee'
{ incorrectSoundEffectFilename } = require '../content/AudioContent.coffee'
{ ImageContent } = require '../content/ImageContent.coffee'
{ VideoContent } = require '../content/VideoContent.coffee'
{ AppConfiguration } = require '../AppConfiguration.coffee'

### --------------------------- ARRAY CUSTOMIZATION --------------------------------- ###

Array::merge = (other) -> Array::push.apply @, other

##
#                                                                
# ContentDownloader                                                          
#
# Given the id of a Curriculum, the CurriculumDownloader fetches all of the 
# images, audio, and videos from the remote server
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
      #try
      #validate the arguments
      console.log "About to download!!"
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

      audio.push correctSoundEffectFilename
      audio.push incorrectSoundEffectFilename

      levels = AppConfiguration.getLevels()
      for level in levels
        images.push level.image

      for curriculum in curriculums
        images.merge @_allFilesInCurriculum curriculum, "IMAGE"
        audio.merge @_allFilesInCurriculum curriculum, "AUDIO"
        video.merge @_allFilesInCurriculum curriculum, "VIDEO"

      removeAlreadyExistingFiles = ( filename )->
        return not OfflineFiles.findOne { filename: filename }

      images = images.filter removeAlreadyExistingFiles
      video = video.filter removeAlreadyExistingFiles
      audio = audio.filter removeAlreadyExistingFiles
      console.log "About to download these files"
      console.log images
      console.log audio
      console.log video

      @_downloadFiles([
        { filenames: images, type: "IMAGE" },
        { filenames: video, type: "VIDEO" },
        { filenames: audio, type: "AUDIO" },
      ])
      .then ->
        onComplete null
      , (err)->
        message = ""
        onComplete err
      , (progress) ->
        AppConfiguration.setPercentLoaded progress
      #catch e
        #onComplete e

    _downloadFiles: ( fileObjects )->
      deferred = Q.defer()
      error = null
      retry = []
      numRecieved = 0
      numToDownload = 0
      totalBytes = 0
      ( numToDownload += obj.filenames.length for obj in fileObjects )

      if fileObjects.length == 0
        deferred.resolve(error)

      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->

        ft = new FileTransfer()

        ft.onprogress = ( event )->
          if event.loaded == event.total
            totalBytes += event.total
          percent = numRecieved / numToDownload
          deferred.notify percent

        downloadFile = ( filename, type )->
          fsPath = fs.root.toURL() + filename
          switch type
            when "AUDIO" then src = AudioContent.getRemoteContent filename
            when "IMAGE" then src = ImageContent.getRemoteContent filename
            when "VIDEO" then src = VideoContent.getRemoteContent filename
            else src = ""

          ft.download( src , fsPath, onSuccess.bind( @, filename, fsPath, type ), onError.bind(@, filename, fsPath, type), true)

        markAsResolved = ( entry )->
          numRecieved++
          console.log "RESOLVED:" + numRecieved + "/"+ numToDownload
          if numRecieved == numToDownload
            console.log "TOTAL BYTES DOWNLOADED #{ totalBytes }"
            deferred.resolve entry

        onSuccess = ( filename, fsPath, type, entry )->
          id = OfflineFiles.insert {
            #url: file.url
            filename: filename
            fsPath: fsPath
          }
          markAsResolved()

        onError = ( filename, type, err )->
          console.log "There was an error: "
          console.log err
          console.log err.code
          console.log err.code == 3
          if err.http_status == 404
            markAsResolved filename
            error = new Meteor.Error("error-downloading", "Some content could not be found")
          else if err.code == 2
            markAsResolved filename
            error = new Meteor.Error("error-downloading", "Error accessing content on server")
          else if err.code == 3
            if filename in retry
              markAsResolved filename
              # If already retried downloading, reject
              error = new Meteor.Error("error-downloading", "Timeout accessing content on server")
            else
              console.log "Retrying download"
              # Try downloading again
              retry.push filename
              downloadFile filename, type
          else
            markAsResolved filename
            error = err

        for obj in fileObjects
          for filename in obj.filenames
            downloadFile filename, obj.type

      , ( err )->
        # Error retrieving the local filesystem
        deferred.resolve err

      return deferred.promise
      
    _allFilesInCurriculum: ( curriculum, type )->
      filenames = []
      lessons = curriculum.getLessonDocuments("introduction")
        .concat curriculum.getLessonDocuments("beginner")
        .concat curriculum.getLessonDocuments("intermediate")
        .concat curriculum.getLessonDocuments("advanced")
      for lesson in lessons
        switch type
          when "IMAGE"
            filenames.merge @_allImagesInLesson(lesson)
          when "AUDIO"
            filenames.merge @_allAudioInLesson(lesson)
          when "VIDEO"
            filenames.merge @_allVideosInLesson(lesson)
      return filenames

    _allImagesInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      filenames = []
      if lesson.image
        filenames.push lesson.image

      for module in modules
        filenames.merge @_allImagesInModule(module)

      return filenames

    _allAudioInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      filenames = []
      for module in modules
        filenames.merge @_allAudioInModule(module)

      return filenames

    _allVideosInLesson: (lesson) ->
      if not lesson?
        return []

      modules = lesson.getModulesSequence()
      filenames = []
      for module in modules
        filenames.merge @_allVideosInModule(module)

      return filenames

    _allImagesInModule: ( module )->
      filenames = []
      if module.image
        filenames.push module.image
      if module.options and module.type == 'MULTIPLE_CHOICE'
        filenames.merge ( option for option in module.options when option?)
      return filenames

    _allVideosInModule: ( module )->
      filenames = []
      if module.video
        filenames.push module.video
      return filenames

    _allAudioInModule: ( module )->
      filenames = []
      if module.audio
        filenames.push module.audio
      if module.correct_audio
        filenames.push module.correct_audio
      return filenames

module.exports.ContentDownloader = ContentDownloader

