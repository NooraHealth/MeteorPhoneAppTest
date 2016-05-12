
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppState } = require('../../api/AppState.coffee')
require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  console.log "In the startup!"
  console.log "Subscribed??", AppState.get().subscribed()
  console.log Curriculums.find().count()
  console.log Lessons.find().count()
  console.log Modules.find().count()
  if Meteor.isCordova and not AppState.get().subscribed()
    console.log "In the meteor isConnected and cordova in init"
    Meteor.subscribe "curriculums.all"
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "modules.all"
    AppState.get().setSubscribed true

  BlazeLayout.setRoot "body"

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )

