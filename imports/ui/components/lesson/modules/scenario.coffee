
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./scenario.html"
    
Template.Lesson_view_page_scenario.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

Template.Lesson_view_page_scenario.helpers
  normalIconSrc: ()->
    return MEDIA_URL + "VascularContent/Images/home.png"
  callDoctorIconSrc: ()->
    return MEDIA_URL + "VascularContent/Images/phone.png"
  emergencyIcon: ()->
    return MEDIA_URL + "VascularContent/Images/emergency.png"

Template.Lesson_view_page_scenario.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target
