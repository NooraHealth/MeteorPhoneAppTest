
{ Curriculums } = require("./collections/schemas/curriculums/curriculums.js")
{ Modules } = require("./collections/schemas/curriculums/modules.js")
{ Lessons } = require("./collections/schemas/curriculums/lessons.js")
{ Translator } = require './utilities/Translator.coffee'

moment = require 'moment'

class AppConfiguration
  @get: ()->
    @config ?= new Private "NooraHealthApp_new"
    return @config

  class Private
    constructor: (name) ->
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
      return ['English', 'Kannada']

    getFacilities: ->
      return [{ name: 'Jayadeva' },{ name: 'Manipal KMC' },{ name: 'Manipal Vijayawada' }]

    getConditions: ->
      return [{ name: 'Cardiac Surgery' }]

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
      condition = @dict.get('app_configuration')?.condition
      new SimpleSchema({
        language: { type: String, optional: true }
        condition: { type: String }
      }).validate {
        language: language
        condition: condition
      }
      curriculum = Curriculums.findOne {language: language, condition: condition}
      return curriculum

    setConfiguration: (configuration) =>
      new SimpleSchema({
        hospital: {type: String, min: 1, optional: true} #Hospital and condition cannot be empty strings
        condition: {type: String, min: 1, optional: true}
      }).validate configuration

      @dict.setPersistent 'app_configuration', configuration
      @

    contentDownloaded: =>
      if Meteor.isCordova
        @dict.get "content_is_downloaded"
      else return true

    setContentDownloaded: (state) =>
      new SimpleSchema({
        state: { type: Boolean }
      }).validate {
        state: state
      }

      @dict.setPersistent "content_is_downloaded", state
      @

    isConfigured: =>
      configuration = @dict.get 'app_configuration'
      return configuration? and
        configuration?.hospital? and
        configuration.hospital isnt "" and
        configuration.condition? and
        configuration.condition isnt ""

    getConfiguration: =>
      return @dict.get "app_configuration"

    getCondition: =>
      return @getConfiguration()?.condition

    getHospital: =>
      return @getConfiguration()?.hospital

    setSubscribed: (state) =>
      new SimpleSchema({
        state: { type: Boolean }
      }).validate {
        state: state
      }

      @dict.setPersistent "is_subscribed", state
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
      subscribed = @dict.get "is_subscribed"
      if subscribed? then return subscribed else return false

    templateShouldSubscribe: ->
      isSubscribed = @isSubscribed()
      return false
      # if Meteor.isCordova
      #   return false
      #   # return Meteor.status().connected and not isSubscribed
      # else
      #   # return Meteor.status().connected
      #   return false
      #return true

    restoreLocalCollectionsFromPersistentStorage: ->
      curriculums = @dict.get "local_curriculums"
      lessons = @dict.get "local_lessons"
      modules = @dict.get "local_modules"

      if curriculums and lessons and modules
        @storeCollectionsLocally JSON.parse(curriculums), JSON.parse(lessons), JSON.parse(modules)

    storeCollectionsLocally: ( curriculums, lessons, modules )->

      Curriculums.remove({})
      Lessons.remove({})
      Modules.remove({})

      for curriculum in curriculums
        Curriculums.insert {
          _id: curriculum._id
          advanced: curriculum.advanced
          intermediate: curriculum.intermediate
          beginner: curriculum.beginner
          introduction: curriculum.introduction
          language: curriculum.language
          condition: curriculum.condition
          title: curriculum.title
        }

      for lesson in lessons
        Lessons.insert {
          _id: lesson._id
          title: lesson.title
          is_active: lesson.is_active
          modules: lesson.modules
        }

      for module in modules
        Modules.insert {
          _id: module._id
          audio: module.audio
          image: module.image
          type: module.type
          question: module.question
          options: module.options
          correct_answer: module.correct_answer
          correct_audio: module.correct_audio
          video: module.video
          is_active: module.is_active
        }

      @dict.setPersistent "local_curriculums", JSON.stringify(curriculums)
      @dict.setPersistent "local_lessons", JSON.stringify(lessons)
      @dict.setPersistent "local_modules", JSON.stringify(modules)

module.exports.AppConfiguration = AppConfiguration.get()
