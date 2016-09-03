
{ TAPi18n } = require("meteor/tap:i18n")

class Translator
  @get: ()->
    @translator ?= new Private "NooraHealthApp"
    return @translator

  class Private
    constructor: ->
      @langTags = {
        english: "en",
        hindi: "hi",
        kannada: "kd"
      }

      @getLangTag = (language) ->
        new SimpleSchema({
          language: { type: String }
        }).validate {
          language: language
        }

        return @langTags[language.toLowerCase()]

    setLanguage: ( language )->
        TAPi18n.setLanguage @getLangTag language

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

#singleton
module.exports.Translator = Translator.get()
