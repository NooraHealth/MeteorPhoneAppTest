
Curriculums = require('./curriculums/curriculums.coffee').Curriculums

class AppState
  @get: ()->
    @dict ?= new Private "NooraHealthApp"
    return @dict

  class Private
    constructor: (name) ->
      @dict = new PersistentReactiveDict name

    setLessonIndex: (i) ->
      @dict.setPersistent "lessonIndex", i

    getLessonIndex: ->
      @dict.get "lessonIndex"

    incrementLesson: ->
      index = @getLessonIndex()
      @setLessonIndex ++index

    setCurriculumDownloaded: (id, state) ->
      @dict.setPersistent "curriculumDownloaded#{id}", state
      
    getCurriculumDownloaded: (id) ->
      if not id then return true
      downloaded = @dict.get "curriculumDownloaded#{id}"
      if not downloaded? then return false else return downloaded
      
    setPercentLoaded: (percent) ->
      @dict.setTemporary "percentLoaded", percent

    getPercentLoaded: ->
      @dict.get "percentLoaded"

    setCurriculumId: (id) ->
      @dict.setPersistent "curriculumId", id
      @setLessonIndex 0

    getCurriculumId: ->
      @dict.get "curriculumId"

    setShouldPlayIntro: (state) ->
      @dict.setPersistent "playIntro", state

    getShouldPlayIntro: (state) ->
      @dict.get "playIntro"

    setError: (error) ->
      if error
        new SimpleSchema({
          reason: {type: String}
          error: {type: String}
        }).validate error

      console.log "SET THE ERROR"
      @dict.setTemporary "errorMessage", error

    getError: ->
      @dict.get "errorMessage"

    loading: ->
      @dict.get "loading"

    setLoading: (state) ->
      @dict.setTemporary "loading", state

module.exports.AppState = AppState
