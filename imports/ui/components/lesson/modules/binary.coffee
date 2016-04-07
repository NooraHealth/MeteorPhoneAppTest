
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    completed: false
  }
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

  @module = Template.currentData().module

  @onSelected = =>
    @state.set "completed", true

Template.Lesson_view_page_binary.helpers
  buttonArgs: (value) ->
    instance = Template.instance()
    module = instance.module
    classes = 'response button button-fill button-big color-lightblue'
    if instance.state.completed
      if module.isCorrectAnswer value
        classes += "correctly-selected expanded"
      else
        classes += 'incorrectly-selected faded'
    return {
      attributes: {
        class: classes
        value: value
      }
      content: value.toUpperCase()
      onClick: instance.onSelected
    }

