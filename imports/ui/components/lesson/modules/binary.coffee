{ ContentInterface } = require('../../../../api/content/ContentInterface.coffee')
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ AppState } = require("../../../../api/AppState.coffee")
require "../../audio/audio.coffee"
require "./binary.html"
require '../../../../api/global_template_helpers.coffee'

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      module: {type: Modules._helpers}
      language: {type: String}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
      onWrongChoice: {type: Function}
      onCorrectChoice: {type: Function}
      onCompletedQuestion: {type: Function}
    }).validate(Template.currentData())
    @data = Template.currentData()

  #set the state
  @state = new ReactiveDict()
  @state.setDefault {
    selected: null
    optionAttributes: {}
  }

  @getOnSelected = (instance, option) ->
    return (event)->
      module = instance.data.module
      instance.state.set "selected", option
      if module.isCorrectAnswer option
        instance.data.onCorrectChoice(option)
        instance.data.onCompletedQuestion()
      else
        instance.data.onWrongChoice(option)

  @questionComplete = ->
    selected = @state.get "selected"
    complete = selected? and @data.module.isCorrectAnswer selected
    return complete

  @autorun =>
    instance = @
    module = instance.data.module
    data = instance.data
    map = {}
    selected = instance.state.get "selected"

    getClasses = (option) ->
      classes = 'response button button-fill button-big color-blue-noora'
      if option is selected
        if module.isCorrectAnswer option
          classes += " #{data.correctlySelectedClasses}"
        else
          classes += " #{data.incorrectlySelectedClasses}"
          classes += " #{data.incorrectClasses}"
      else if instance.questionComplete()
        classes += " #{data.incorrectClasses}"
      return classes
    
    mapData = (option, i) ->
      map[option] = {
        id: "#{option}OptionForModule#{module._id}"
        class: getClasses(option)
        value: option
      }
    mapData(option, i) for option, i in module.options
    instance.state.set "optionAttributes", map

Template.Lesson_view_page_binary.helpers
  buttonArgs: (option, language) ->
    instance = Template.instance()
    attributes = instance.state.get "optionAttributes"
    text = AppState.translate option.toLowerCase(), language, "UPPER"
    return {
      attributes: attributes[option]
      content: text.toUpperCase()
      onClick: instance.getOnSelected(instance, option)
    }

