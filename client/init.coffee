Meteor.startup ()->
  BlazeLayout.setRoot "body"

  this.App = new Framework7(
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )
