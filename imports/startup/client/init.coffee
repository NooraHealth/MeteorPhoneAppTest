{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  BlazeLayout.setRoot "body"
  console.log "Importing Framework7"
  console.log "This is Framework7"
  console.log Framework7

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )
