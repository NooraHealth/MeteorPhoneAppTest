
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')

require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  TAPi18n.setLanguage "en"
  BlazeLayout.setRoot "body"
  AppConfiguration.initializeApp()

  if (Meteor.isCordova and not AppConfiguration.isSubscribed()) or Meteor.status().connected
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "curriculums.all"
    Meteor.subscribe "modules.all"
    AppConfiguration.setSubscribed true


  if not AppConfiguration.isConfigured()
    FlowRouter.go "configure"
  else if not AppConfiguration.contentDownloaded() and Meteor.isCordova
    FlowRouter.go "load"
  else
    FlowRouter.go "home"
