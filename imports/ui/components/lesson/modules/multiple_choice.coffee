
require "./multiple_choice.html"

Template.Lesson_view_page_multiple_choice.helpers
  secondRow: ()->
    return @.getOptions 3, 6
  firstRow: ()->
    return @.getOptions 0, 3
  module: ()->
    return @

Template.Lesson_view_page_multiple_choice.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target


