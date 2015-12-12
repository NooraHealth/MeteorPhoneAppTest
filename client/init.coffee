Meteor.startup ()->
  sceneInit = Scene.get()

  BlazeLayout.setRoot "body"
  this.Subs = new SubsManager()

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )
