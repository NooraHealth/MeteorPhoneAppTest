
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
      index = @dict.get "lessonIndex"
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
      @dict.setPersistent "playedIntro", state

    getShouldPlayIntro: (state) ->
      @dict.get "playedIntro"

module.exports.AppState = AppState
