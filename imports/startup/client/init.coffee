
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppState } = require('../../api/AppState.coffee')
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  TAPi18n.setLanguage "en"

  if (Meteor.isCordova and not AppState.isSubscribed()) or Meteor.status().connected
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "curriculums.all"
    Meteor.subscribe "modules.all"
    AppState.setSubscribed true

  BlazeLayout.setRoot "body"

  AppState.initializeApp()
  if not AppState.isConfigured()
    FlowRouter.go "configure"
  else if not AppState.contentDownloaded()
    FlowRouter.go "load"
  else
    FlowRouter.go "select_language"

