
{ Curriculums } = require("./collections/schemas/curriculums/curriculums.js")
{ Modules } = require("./collections/schemas/curriculums/modules.js")
{ Lessons } = require("./collections/schemas/curriculums/lessons.js")
{ Translator } = require './utilities/Translator.coffee'

moment = require 'moment'

class AppConfiguration
  @get: ()->
    @config ?= new Private "NooraHealthApp"
    return @config

  class Private
    constructor: (name) ->
      console.log "MAKING AN APP CONFIGURATION"
      @dict = new PersistentReactiveDict name
      console.log @dict

    initializeApp: =>
      @F7 = new Framework7(
        materialRipple: true
        router:false
        tapHold: true
        tapHoldPreventClicks: false
        tapHoldDelay: 1500
      )
      @

    getLevels: ->
      return [
        { name: "beginner", image: "easy.png" }
        { name: "intermediate", image: "medium.png" }
        { name: "advanced", image: "hard.png" }
      ]

    getSupportedLanguages: ->

    getF7: =>
      return @F7

    setPercentLoaded: (percent) =>
      @dict.setTemporary "percentLoaded", percent
      @

    getPercentLoaded: =>
      @dict.get "percentLoaded"

    setLanguage: (language) =>
      new SimpleSchema({
        language: { type: String }
      }).validate {
        language: language
      }

      Translator.setLanguage language
      @dict.setTemporary "language", language
      @

    getLanguage: =>
      language = @dict.get "language"
      if not language? then return "English" else return language

    getCurriculumDoc: ->
      language = @dict.get "language"
      condition = @dict.get('configuration')?.condition
      new SimpleSchema({
        language: { type: String, optional: true }
        condition: { type: String }
      }).validate {
        language: language
        condition: condition
      }
      console.log language
      console.log condition
      console.log Curriculums.find({}).count()
      curriculum = Curriculums.findOne {language: language, condition: condition}
      console.log "The curriculum"
      return curriculum

    setConfiguration: (configuration) =>
      new SimpleSchema({
        hospital: {type: String, min: 1, optional: true} #Hospital and condition cannot be empty strings
        condition: {type: String, min: 1, optional: true}
      }).validate configuration

      @dict.setPersistent 'configuration', configuration
      @

    contentDownloaded: =>
      if Meteor.isCordova
        @dict.get "content_downloaded"
      else return true

    setContentDownloaded: (state) =>
      new SimpleSchema({
        state: { type: Boolean }
      }).validate {
        state: state
      }

      @dict.setPersistent "content_downloaded", state
      @

    isConfigured: =>
      configuration = @dict.get 'configuration'
      return configuration? and
        configuration?.hospital? and
        configuration.hospital isnt "" and
        configuration.condition? and
        configuration.condition isnt ""

    getConfiguration: =>
      return @dict.get "configuration"

    getCondition: =>
      return @getConfiguration()?.condition

    getHospital: =>
      return @getConfiguration()?.hospital

    setSubscribed: (state) =>
      console.log "Setting subscribed to "
      console.log state
      new SimpleSchema({
        state: { type: Boolean }
      }).validate {
        state: state
      }

      @dict.setTemporary "subscribed", state
      @

    getCurrentUserId: =>
      return @dict.get "user_id"

    setCurrentUserId: =>
      hospital = @getHospital()
      condition = @getCondition()
      language = @getLanguage()
      id = "#{hospital}, #{language}: " + moment().format("DD/MM/YYYY hh:mm")
      @dict.set "user_id", id

    isSubscribed: =>
      subscribed = @dict.get "subscribed"
      console.log "isSubscribed", subscribed
      if subscribed? then return subscribed else return false

    templateShouldSubscribe: ->
      isSubscribed = @isSubscribed()
      if Meteor.isCordova
        return false
        # return Meteor.status().connected and not isSubscribed
      else
        # return Meteor.status().connected
        return false
      #return true

    restoreLocalCollectionsFromPersistentStorage: ( curriculums, lessons, modules )->
      curriculums = JSON.parse @dict.get "curriculums"
      lessons = JSON.parse @dict.get "lessons"
      modules = JSON.parse @dict.get "modules"

      @_storeCollectionsLocally curriculums, lessons, modules

    storeCollectionsLocally: ( curriculums, lessons, modules )->
      console.log "STORING COLLECTIONS LOCALLY"
      console.log curriculums
      console.log lessons
      console.log modules
      Curriculums.remove({})
      Lessons.remove({})
      Modules.remove({})

      for curriculum in curriculums
        Curriculums.insert curriculum

      for lesson in lessons
        Lessons.insert lesson

      for module in modules
        Modules.insert module

      @dict.setPersistent "curriculums", JSON.stringify(curriculums)
      @dict.setPersistent "lessons", JSON.stringify(lessons)
      @dict.setPersistent "modules", JSON.stringify(modules)

module.exports.AppConfiguration = AppConfiguration.get()
