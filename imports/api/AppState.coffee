
Curriculums = require('./curriculums/curriculums.coffee').Curriculums

class AppState
  @get: ()->
    @dict ?= new Private "NooraHealthApp"
    return @dict

  class Private
    constructor: (name) ->
      @dict = new PersistentReactiveDict name
      console.log "The persistent Dict app state"
      console.log @dict
      #@dict.setDefaultPersistent {
        #lessonIndex: 0
        #curriculumDownloaded: false
        #playedIntro: false
        #curriculumId: null
      #}

      #@dict.setDefaultTemporary {
        #percentLoaded: 0
      #}

    setLessonIndex: (i) ->
      @dict.setPersistent "lessonIndex", i

    getLessonIndex: ->
      @dict.get "lessonIndex"

    incrementLesson: ->
      id = @getCurriculumId()
      numLessons = Curriculums.findOne({_id: id}).lessons.length
      index = @dict.get "lessonIndex"
      @setLessonIndex((++index) % numLessons)

    setCurriculumDownloaded: (id, state) ->
      console.log "Setting the curriculum downloaded of #{id} to #{state}"
      @dict.setPersistent "curriculumDownloaded#{id}", state
      
    getCurriculumDownloaded: (id) ->
      console.log "Is there an id?", id
      if not id then return true
      downloaded = @dict.get "curriculumDownloaded#{id}"
      console.log "GETTIGN the curriculum downloaded of #{id}: ", downloaded
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
      console.log "setting whether should play intro to ", state
      @dict.setPersistent "playedIntro", state

    getShouldPlayIntro: (state) ->
      @dict.get "playedIntro"

    setDownloadError: (id, error) ->
      @dict.setTemporary "errordownloading#{id}", error

    getDownloadError: (id) ->
      @dict.get "errordownloading#{id}"

    loading: ->
      @dict.get "loading"

    setLoading: (state) ->
      @dict.set "loading", state

module.exports.AppState = AppState
