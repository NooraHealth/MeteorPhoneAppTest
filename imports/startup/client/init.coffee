
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppConfiguration } = require('../../api/AppConfiguration.coffee')
{ ExternalCurriculums } = require('../../api/collections/schemas/curriculums/curriculums.js')
{ ExternalLessons } = require('../../api/collections/schemas/curriculums/lessons.js')
{ ExternalModules } = require('../../api/collections/schemas/curriculums/modules.js')

require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  console.log Meteor.status()
  TAPi18n.setLanguage "en"
  BlazeLayout.setRoot "body"
  AppConfiguration.initializeApp()

  AppConfiguration.fillLocalCollectionsFromStorage()
  # if not AppConfiguration.isConfigured()
  #   # facilitiesHandle = Meteor.subscribe "facilities.all"
  #   # conditionsHandle = Meteor.subscribe "conditions.all"
  #   currHandle = Meteor.subscribe "curriculums.all"
  #   lessonsHandle = Meteor.subscribe "lessons.all"
  #   modulesHandle = Meteor.subscribe "modules.all"
  #   AppConfiguration.setSubscribed true
  #
  #   firstRun = true
  #   Tracker.autorun ->
  #     console.log "READY??"
  #     if currHandle.ready() and lessonsHandle.ready() and modulesHandle.ready() and firstRun
  #       console.log "READY!!!!"
  #       firstRun = false
  #       curriculums = ExternalCurriculums.find({}).fetch()
  #       modules = ExternalModules.find({}).fetch()
  #       lessons = ExternalLessons.find({}).fetch()
  #       AppConfiguration.storeCollectionsLocally curriculums, lessons, modules
  # else
  #   Meteor.disconnect()

  if not AppConfiguration.isConfigured()
    FlowRouter.go "configure"
  else if not AppConfiguration.contentDownloaded() and Meteor.isCordova
    FlowRouter.go "load"
  else
    FlowRouter.go "home"
