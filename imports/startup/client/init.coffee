{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ Framework7 } = require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  BlazeLayout.setRoot "body"

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )
