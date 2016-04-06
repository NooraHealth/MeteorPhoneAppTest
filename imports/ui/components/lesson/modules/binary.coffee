
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

  @module = Template.currentData().module

  @getOnSelectedCallback = (buttonValue, correctAnswer) ->

Template.Lesson_view_page_binary.helpers
  noButtonArgs: ->
    instance = Template.instance()
    classes = 'response button button-fill button-big color-lightblue'
    return {
      class: classes
      value: 'No'
      content: 'NO'
      onSelected: instance.onNoSelected
    }

  yesButtonArgs: ->
    instance = Template.instance()
    return {
      class: 'response button button-fill button-big color-lightblue'
      value: 'Yes'
      content: 'YES'
      onSelected: instance.onYesSelected
    }

