
require 'meteor/loftsteinn:framework7-ios'
cloudinary = require("cloudinary")

{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppState } = require('../../api/AppState.coffee')
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")


Meteor.startup ()->
  TAPi18n.setLanguage "en"
  BlazeLayout.setRoot "body"
  AppState.initializeApp()

  if (Meteor.isCordova and not AppState.isSubscribed()) or Meteor.status().connected
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "curriculums.all"
    Meteor.subscribe "modules.all"
    AppState.setSubscribed true

  cloudinary.config {
    cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
    api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
    api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
  }

  if not AppState.isConfigured()
    FlowRouter.go "configure"
  else if not AppState.contentDownloaded() and Meteor.isCordova
    FlowRouter.go "load"
  else
    FlowRouter.go "home"

