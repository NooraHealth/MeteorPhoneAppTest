
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ TAPi18n } = require("meteor/tap:i18n")

class AppState
  @get: ()->
    @dict ?= new Private "NooraHealthApp"
    return @dict

  class Private
    constructor: (name) ->
      @dict = new PersistentReactiveDict name
      @dict.set "route", "Home_page"
      @levels = [
        { name: "beginner", image: "easy.png"},
        { name: "intermediate", image: "medium.png"},
        { name: "advanced", image: "hard.png"}
      ]
      
      @langTags = {
        english: "en",
        hindi: "hi",
        kannada: "kd"
      }

    initializeApp: =>
      @F7 = new Framework7(
        materialRipple: true
        router:false
        tapHold: true
        tapHoldPreventClicks: false
        tapHoldDelay: 1500
      )

    getF7: =>
      return @F7

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
      TAPi18n.setLanguage @_getLangTag language
      @dict.setTemporary "language", language
      @

    getLanguage: ->
      language = @dict.get "language"
      if not language? then return null else return language

    translate: ( key, language, textCase, options)->
      tag = @_getLangTag language
      text = TAPi18n.__ key, options, tag
      if textCase == "UPPER"
        return text.toUpperCase()
      if textCase == "LOWER"
        return text.toLowerCase()
      else
        return text

    _getLangTag: (language) ->
      if not language
        return null
      return @langTags[language.toLowerCase()]

    getCurriculumDoc: ->
      if not @isConfigured()
        @setError new Meteor.Error("developer-error", "The app is calling setConfiguration after it has already been configured. This should not have happened. Developer error")

      language = @dict.get "language"
      condition = @dict.get('configuration').condition
      if not language? or not condition?
        return null
      curriculum = Curriculums.findOne {language: language, condition: condition}
      return curriculum

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

    contentDownloaded: ->
      @dict.get "content_downloaded"

    setContentDownloaded: (value) ->
      @dict.setPersistent "content_downloaded", value

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
      return curriculum?[levelName]

    getLevels: =>
      return @levels

    getIntroductionModule: ()->
      curriculum = @getCurriculumDoc()
      lesson = Lessons.findOne { _id: curriculum.introduction }
      moduleId = lesson?.modules[0]
      return Modules.findOne { _id: moduleId }

    isSubscribed: ->
      subscribed = @dict.get "subscribed"
      if subscribed? then return subscribed else return false

module.exports.AppState = AppState.get()
