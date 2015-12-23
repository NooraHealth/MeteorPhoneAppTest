    
Template.scenarioModule.helpers
  normalIconSrc: ()->
    return MEDIA_URL + "VascularContent/Images/home.png"
  callDoctorIconSrc: ()->
    return MEDIA_URL + "VascularContent/Images/phone.png"
  emergencyIcon: ()->
    return MEDIA_URL + "VascularContent/Images/emergency.png"

Template.scenarioModule.events
  'click .scenario-btn': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target
