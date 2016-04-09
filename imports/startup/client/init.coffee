{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
require 'meteor/loftsteinn:framework7-ios'
AppState = require('../../api/AppState.coffee').AppState

Meteor.startup ()->
  BlazeLayout.setRoot "body"
  AppState.get().setPlayedIntro false

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )

