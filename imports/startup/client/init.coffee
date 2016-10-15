
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')
{ Curriculums } = require('../../api/collections/schemas/curriculums/curriculums.coffee')
{ ExternalLessons } = require('../../api/collections/schemas/curriculums/lessons.coffee')
{ ExternalModules } = require('../../api/collections/schemas/curriculums/modules.coffee')

require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  TAPi18n.setLanguage "en"
  BlazeLayout.setRoot "body"
  AppConfiguration.initializeApp()

  console.log process.env.MONGO_URL
  console.log "IN INIT"
  console.log "App is subscribed?? " + AppConfiguration.isSubscribed()
  if not AppConfiguration.isSubscribed()
    alert "SUBSCRIBING in the init"
    Meteor.subscribe "facilities.all"
    Meteor.subscribe "conditions.all"
    currHandle = Meteor.subscribe "curriculums.all"
    lessonsHandle = Meteor.subscribe "lessons.all"
    modulesHandle = Meteor.subscribe "modules.all"
    AppConfiguration.setSubscribed true
    console.log "Setting a tracker autorun"
    Tracker.autorun ->
      console.log "WHEN TO STORE SUBSCRIPTIONS LOCALLY"
      if currHandle.ready() and lessonsHandle.ready() and modulesHandle.ready()
        curriculums = ExternalCurriculums.find({}).fetch()
        modules = ExternalModules.find({}).fetch()
        lessons = ExternalLessons.find({}).fetch()
        AppConfiguration.storeCollectionsLocally curriculums, lessons, modules
  else
    Meteor.disconnect()

  if not AppConfiguration.isConfigured()
    FlowRouter.go "configure"
  else if not AppConfiguration.contentDownloaded() and Meteor.isCordova
    FlowRouter.go "load"
  else
    FlowRouter.go "home"
