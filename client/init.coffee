Meteor.startup ()->
  BlazeLayout.setRoot "body"
  this.Subs = new SubsManager()

  this.App = new Framework7(
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )
