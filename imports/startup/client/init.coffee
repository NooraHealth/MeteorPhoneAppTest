
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppState } = require('../../api/AppState.coffee')
require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  if Meteor.isCordova
    Meteor.subscribe "curriculums.all"
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "modules.all"
  BlazeLayout.setRoot "body"
  AppState.get().setShouldPlayIntro true

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )

