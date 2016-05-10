
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

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

    setConfiguration: (configuration) ->
      if not Meteor.isCordova
        throw Meteor.Error "developer-error", "The app should not call AppState.get().setConfiguration when not in Cordova. Developer error."

      if @isConfigured()
        throw Meteor.Error "developer-error", "The app is calling setConfiguration after it has already been configured. This should not have happened. Developer error"

      new SimpleSchema({
        hospital: {type: String, min: 1} #Hospital and condition cannot be empty strings
        condition: {type: String, min: 1}
      }).validate configuration

      @dict.setPersistent 'configuration', configuration
      #@dict.setPersistent 'hospital', configuration.hospital
      #@dict.setPersistent 'condition', configuration.condition

    isConfigured: (state) ->
      if Meteor.isCordova
        configuration = @dict.get 'configuration'
        #hospital = @dict.get 'hospital'
        #condition = @dict.get 'condition'
        return configuration? and
          configuration?.hospital? and
          configuration.hospital isnt "" and
          configuration.condition? and
          configuration.condition isnt ""
      else
        throw Meteor.Error 'developer-error', 'App reached AppState.get().isConfigured while not in Cordova. This should not have happened. Developer Error'

    getConfiguration: ->
      if not Meteor.isCordova
        throw Meteor.Error "developer-error", "The app should not call AppState.get().getConfiguration when not in Cordova. Developer error."

      if not @isConfigured()
        throw Meteor.Error "developer-error", "The app is calling getConfiguration before it has been configured. This should not have happened. Developer error"

      return @dict.get "configuration"

module.exports.AppState = AppState
