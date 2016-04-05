
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

Template.Lesson_view_page_binary.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target

