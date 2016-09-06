
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'

{ AppConfiguration } = require('../../api/AppConfiguration.coffee')

{ ContentInterface } = require('../../api/content/ContentInterface.coffee')

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

require 'meteor/loftsteinn:framework7-ios'

cloudinary = require("cloudinary")

Meteor.startup ()->
  TAPi18n.setLanguage "en"
  BlazeLayout.setRoot "body"
  AppConfiguration.initializeApp()

  if (Meteor.isCordova and not AppConfiguration.isSubscribed()) or Meteor.status().connected
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "curriculums.all"
    Meteor.subscribe "modules.all"
    AppConfiguration.setSubscribed true

  cloudinary.config {
    cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
    api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
    api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
  }
  console.log cloudinary
  console.log "CONFIGED"
  src = ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO")
  console.log cloudinary.url( src, {}, ( result ) ->
    console.log result
  )


  if not AppConfiguration.isConfigured()
    FlowRouter.go "configure"
  else if not AppConfiguration.contentDownloaded() and Meteor.isCordova
    FlowRouter.go "load"
  else
    FlowRouter.go "home"

