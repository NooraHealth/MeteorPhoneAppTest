
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

  @getOptions = (module, start, end) ->
    if not module.options then []

    NUM_OBJECTS_PER_ROW = 3
    options = ({option: option, optionImgSrc: module.optionSrc(i), i: i, correct: module.isCorrect(option)} for option, i in module.options when i >= start and i < end)
    return {options: options}
  
Template.Lesson_view_page_multiple_choice.helpers
  getOptions: (module, start, end) ->
    console.log module
    console.log start
    console.log end
    if not module.options then {options: []}

    NUM_OBJECTS_PER_ROW = 3
    options = ({option: option, optionImgSrc: module.optionSrc(i), i: i, correct: module.isCorrectAnswer(option)} for option, i in module.options when i >= start and i < end)
    return {options: options}

Template.Lesson_view_page_multiple_choice.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target


