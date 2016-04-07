
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    noSelected: false
    yesSelected: false
  }

  @autorun =>
    console.log "Validating binary", Template.currentData()
    console.log Template.currentData()
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
    }).validate(Template.currentData())

  @module = Template.currentData().module

  @getClasses = (value) ->
    classes = 'response button button-fill button-big color-lightblue'

  @onSelected = (module) ->
    return (event)->
      value = $(event.target).val()
      console.log "Value of selected button", value
      if module.isCorrectAnswer value
        @state.set "completed", true



Template.Lesson_view_page_binary.helpers
  buttonArgs: (value) ->
    instance = Template.instance()
    module = instance.module
    data = Template.currentData()
    return {
      attributes: {
        class: instance.getClasses value
        value: value
      }
      content: value.toUpperCase()
      onClick: instance.onSelected
    }

