
###
# Initial Session variables
###
if Meteor.Device.isPhone()
  Session.set "lesson card width", 325
  Session.set "lesson card height", 300
else
  Session.set "lesson card width", 400
  Session.set "lesson card height", 400
Session.set "chapters complete", ""
Session.set "current transition", "slideWindowLeft"
Session.set "display trophy", false
#}

