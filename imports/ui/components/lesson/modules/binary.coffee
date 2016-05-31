{ ContentInterface } = require('../../../../api/content/ContentInterface.coffee')
{ Modules } = require("meteor/noorahealth:mongo-schemas")
require '../../../../api/content/global_template_helpers.coffee'
require "../../audio/audio.coffee"
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      module: {type: Modules._helpers}
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
    buttonAttributes: {}
  }

  @getOnSelected = (instance, option) ->
    return (event)->
      module = instance.data.module
      instance.state.set "selected", option
      if module.isCorrectAnswer option
        instance.data.onCorrectChoice()
        instance.data.onCompletedQuestion()
      else
        instance.data.onWrongChoice()

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
      classes = 'response button button-fill button-big color-lightblue'
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
        class: getClasses(option)
        value: option
      }
    mapData(option, i) for option, i in module.options
    instance.state.set "optionAttributes", map

Template.Lesson_view_page_binary.helpers
  buttonArgs: (option) ->
    instance = Template.instance()
    attributes = instance.state.get "optionAttributes"
    return {
      attributes: attributes[option]
      content: option.toUpperCase()
      onClick: instance.getOnSelected(instance, option)
    }

