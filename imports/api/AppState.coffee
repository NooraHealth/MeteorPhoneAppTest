
class AppState
  @get: ()->
    @dict ?= new Private "NooraHealthApp"
    return @dict

  class Private
    constructor: (name) ->
      @dict = new PersistentReactiveDict name

    incrementLesson: ->
      index = @dict.get "lessonIndex"
      @setLessonIndex ++index

    setLessonIndex: (i) ->
      @dict.set "lessonIndex", i

    getLessonIndex: ->
      @dict.get "lessonIndex"

    getCurriculumId: ->
      @dict.get "curriculumId"

    setCurriculumId: (id) ->
      @dict.set "curriculumId", id
      @setLessonIndex 0

    shouldPlayIntro: (state) ->
      @dict.get "playedIntro"

    setShouldPlayIntro: (state) ->
      @dict.set "playedIntro", state

module.exports.AppState = AppState
