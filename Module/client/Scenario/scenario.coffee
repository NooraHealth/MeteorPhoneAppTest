Template.scenarioModule.helpers
  normalIconSrc: ()->
    return MEDIA_URL + "VascularContent/Images/home.png"
  
  callDoctorIconSrc: ()->
    return MEDIA_URL + "VascularContent/Images/home.png"

  emergencyIcon: ()->
    return MEDIA_URL + "VascularContent/Images/emergency.png"

  imgSrc: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + @.image

