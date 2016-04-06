
Modules = require('../../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"
require "./option.coffee"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    completed: false
    numCorrectResponses: 0
  }

  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

  @module = Template.currentData().module

  @getOptionCallback = (module, state) ->
    return (option) ->
      if option.correct
        num = state.get "numCorrectResponses"
        state.set "numCorrectResponses", ++num
        if num == module.correct_answer.length
          state.set "completed", true

Template.Lesson_view_page_multiple_choice.helpers
  optionArgs: (option) ->
    instance = Template.instance()
    module = instance.module
    return {
      option: option
      onSelected: instance.getOptionCallback(module, instance.state)
      questionComplete: instance.state.get "completed"
    }

  getOptions: (module, start, end) ->
    instance = Template.instance()
    NUM_OBJECTS_PER_ROW = 3
    if not module.options then {options: []}
    getOptionData = (option, i) =>
      return {
        i: i
        option: option
        src: module.optionSrc(i)
        correct: module.isCorrectAnswer(option)
      }
    options = (getOptionData(option, i) for option, i in module.options when i >= start and i < end)
    return {options: options}

