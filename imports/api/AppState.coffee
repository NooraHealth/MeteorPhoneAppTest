
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
      
      @langTags = {
        english: "en",
        hindi: "hi",
        kannada: "kd"
      }

      @getLangTag = (language) =>
        new SimpleSchema({
          language: { type: String }
        }).validate {
          language: language
        }

        return @langTags[language.toLowerCase()]

    initializeApp: =>
      @F7 = new Framework7(
        materialRipple: true
        router:false
        tapHold: true
        tapHoldPreventClicks: false
        tapHoldDelay: 1500
      )
      @

    getF7: =>
      return @F7
      
    setPercentLoaded: (percent) =>
      new SimpleSchema({
        percent: { type: Number }
      }).validate {
        percent: percent
      }

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

      TAPi18n.setLanguage @getLangTag language
      @dict.setTemporary "language", language
      @

    getLanguage: =>
      language = @dict.get "language"
      if not language? then return "English" else return language

    translate: ( key, language, textCase, options) =>

      new SimpleSchema({
        key: { type: String, optional: true }
        language: { type: String, optional: true }
        textCase: { type: String, optional: true }
      }).validate {
        key: key
        language: language
        textCase: textCase
      }

      tag = @getLangTag language
      text = TAPi18n.__ key, options, tag
      if textCase == "UPPER"
        return text.toUpperCase()
      if textCase == "LOWER"
        return text.toLowerCase()
      else
        return text

    getCurriculumDoc: =>
      language = @dict.get "language"
      condition = @dict.get('configuration')?.condition
      new SimpleSchema({
        language: { type: String }
        condition: { type: String }
      }).validate {
        language: language,
        condition: condition
      }

      curriculum = Curriculums.findOne {language: language, condition: condition}
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
      new SimpleSchema({
        state: { type: Boolean }
      }).validate {
        state: state
      }

      @dict.setPersistent "subscribed", state
      @

    isSubscribed: =>
      subscribed = @dict.get "subscribed"
      if subscribed? then return subscribed else return false

    templateShouldSubscribe: ->
      isSubscribed = @isSubscribed()
      if Meteor.isCordova
        return Meteor.status().connected and not isSubscribed
      else
        return Meteor.status().connected

module.exports.AppState = AppState.get()
