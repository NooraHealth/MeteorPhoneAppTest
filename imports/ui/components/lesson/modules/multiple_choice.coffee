
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

  @getOptions = (module, start, end) ->
    NUM_OBJECTS_PER_ROW = 3
    url = ContentInterface.getContentSrc()

    if not @.options
      return []

    isCorrect = (option)=>
      return option in @.correct_answer

    options = ({option: option, optionImgSrc: module.optionSrc(i), i: i, correct: module.isCorrect(option)} for option, i in module.options when i >= start and i < end)
    return {options: options}
  
Template.Lesson_view_page_multiple_choice.helpers
  secondRow: ()->
    #return @.getOptions 3, 6
  firstRow: ()->
    #return @.getOptions 0, 3

Template.Lesson_view_page_multiple_choice.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target


