
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

class AppState
  @get: ()->
    @dict ?= new Private "NooraHealthApp"
    return @dict

  class Private
    constructor: (name) ->
      @dict = new PersistentReactiveDict name
      @dict.set "route", "Home_page"

    setLessonIndex: (i) ->
      @dict.setPersistent "lessonIndex", i
      @

    getLessonIndex: ->
      @dict.get "lessonIndex"

    incrementLesson: ->
      index = @getLessonIndex()
      @setLessonIndex ++index
      @

    setCurriculumDownloaded: (id, state) ->
      @dict.setPersistent "curriculumDownloaded#{id}", state
      @
      
    getCurriculumDownloaded: (id) ->
      if not id then return true
      downloaded = @dict.get "curriculumDownloaded#{id}"
      if not downloaded? then return false else return downloaded
      
    setPercentLoaded: (percent) ->
      @dict.setTemporary "percentLoaded", percent
      @

    getPercentLoaded: ->
      @dict.get "percentLoaded"

    setLanguage: (language) ->
      @dict.setPersistent "language", language
      @setLessonIndex 0
      @

    getLanguage: ->
      @dict.get "language"

    getCurriculumId: ->
      if not @isConfigured()
        @setError new Meteor.Error("developer-error", "The app is calling setConfiguration after it has already been configured. This should not have happened. Developer error")

      language = @dict.get "language"
      condition = @dict.get('configuration').condition
      if not language? or not condition?
        return null
      curriculum = Curriculums.findOne {language: language, condition: condition}
      return curriculum?._id

    setShouldPlayIntro: (state) ->
      @dict.setPersistent "playIntro", state
      @

    getShouldPlayIntro: (state) ->
      shouldPlay = @dict.get "playIntro"
      if shouldPlay? then return shouldPlay else return false

    setError: (error) ->
      if error
        new SimpleSchema({
          reason: {type: String}
          error: {type: String}
        }).validate error

      @dict.setTemporary "errorMessage", error
      return @

    getError: ->
      @dict.get "errorMessage"

    setConfiguration: (configuration) ->
      if not Meteor.isCordova
        @setError new Meteor.Error("developer-error", "The app should not call AppState.get().setConfiguration when not in Cordova. Developer error.")

      new SimpleSchema({
        hospital: {type: String, min: 1, optional: true} #Hospital and condition cannot be empty strings
        condition: {type: String, min: 1, optional: true}
      }).validate configuration

      @dict.setPersistent 'configuration', configuration
      return @

    isConfigured: (state) ->
      if Meteor.isCordova
        configuration = @dict.get 'configuration'
        return configuration? and
          configuration?.hospital? and
          configuration.hospital isnt "" and
          configuration.condition? and
          configuration.condition isnt ""
      else
        throw Meteor.Error('developer-error', 'App reached AppState.get().isConfigured while not in Cordova. This should not have happened. Developer Error')

    getConfiguration: ->
      if not Meteor.isCordova
        @setError new Meteor.Error("developer-error", "The app should not call AppState.get().getConfiguration when not in Cordova. Developer error.")

      if not @isConfigured()
        @setError new Meteor.Error("developer-error", "The app is calling getConfiguration before it has been configured. This should not have happened. Developer error")

      return @dict.get "configuration"

    getCondition: ->
      return @getConfiguration().condition

    getHospital: ->
      return @getConfiguration().hospital

    setSubscribed: (state) ->
      @dict.set "subscribed", state
      return @

    isSubscribed: ->
      subscribed = @dict.get "subscribed"
      if subscribed? then return subscribed else return false

    #setRoute: (route) ->
      #@dict.setTemporary "route", route
      #@

    #route: ->
      #console.log "Returning the route"
      #console.log @dict.get "route"
      #@dict.get "route"

    #setLessonId: (id) ->
      #@dict.setTemporary "lessonId", id

    #getLessonId: ->
      #@dict.get "lessonId"

module.exports.AppState = AppState
