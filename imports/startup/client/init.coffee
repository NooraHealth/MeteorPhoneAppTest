
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppState } = require('../../api/AppState.coffee')
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  console.log "STARTED APPSEE #{Meteor.settings.public.APPSEE_API_KEY}"
  #Appsee.start(Meteor.settings.public.APPSEE_API_KEY)
  if (Meteor.isCordova and not AppState.get().isSubscribed()) or Meteor.status().connected
    console.log("Subscribing to all")
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "curriculums.all"
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

