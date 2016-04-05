
require "./scenario.html"
    
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
