
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())
  
Template.Lesson_view_page_multiple_choice.helpers
  secondRow: ()->
    #return @.getOptions 3, 6
  firstRow: ()->
    #return @.getOptions 0, 3

Template.Lesson_view_page_multiple_choice.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target


