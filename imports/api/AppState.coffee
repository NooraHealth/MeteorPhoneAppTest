
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ Modules } = require("meteor/noorahealth:mongo-schemas")

class AppState
  @get: ()->
    @dict ?= new Private "NooraHealthApp"
    return @dict

  class Private
    constructor: (name) ->
      @dict = new PersistentReactiveDict name
      @dict.set "route", "Home_page"
      @levels = [
        { name: "EASY", image: "easy.png"},
        { name: "MEDIUM", image: "medium.png"},
        { name: "HARD", image: "hard.png"}
      ]

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
      @

    getLanguage: ->
      language = @dict.get "language"
      if not language? then return null else return language

    getCurriculumDoc: ->
      if not @isConfigured()
        @setError new Meteor.Error("developer-error", "The app is calling setConfiguration after it has already been configured. This should not have happened. Developer error")

      language = @dict.get "language"
      condition = @dict.get('configuration').condition
      if not language? or not condition?
        return null
      curriculum = Curriculums.findOne {language: language, condition: condition}
      return curriculum

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

    setLevel: ( level )=>
      @dict.set "level", level

    getLevel: =>
      level = @dict.get "level"
      if level?
        return level
      else
        defaultLevel = @levels[0].name
        @setLevel( defaultLevel )
        return defaultLevel

    ##TODO this is a hack
    incrementLevel: =>
      level = @dict.get "level"
      if level == @levels[0].name
        console.log "Setting level to @levels[1]"
        @dict.set "level", @levels[1].name
      else if level == @levels[1].name
        console.log "Setting level to @levels[2]"
        @dict.set "level", @levels[2].name
      else if level == @levels[2].name
        console.log "Setting level to @levels[3]"
        @dict.set "level", @levels[0].name
      else
        console.log "Setting level to @levels[0]"
        @dict.set "level", @levels[0].name

    getLessons: ( levelName )=>
      curriculum = @getCurriculumDoc()
      if levelName == @levels[0].name
        return curriculum.lessons.slice(1, 2)
      if levelName == @levels[1].name
        return curriculum.lessons.slice(2, 4)
      if levelName == @levels[2].name
        return curriculum.lessons.slice(4, 6)

    getLevels: =>
      return @levels

    getIntroductionModule: ()->
      curriculum = @getCurriculumDoc()
      lesson = Lessons.findOne { _id: curriculum?.lessons?[0] }
      moduleId = lesson?.modules[0]
      return Modules.findOne { _id: moduleId }

    isSubscribed: ->
      subscribed = @dict.get "subscribed"
      if subscribed? then return subscribed else return false

module.exports.AppState = AppState
