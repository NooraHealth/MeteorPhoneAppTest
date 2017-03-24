
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
  
  if not AppConfiguration.isConfigured()
    FlowRouter.go "configure"
  else if not AppConfiguration.contentDownloaded() and Meteor.isCordova
    FlowRouter.go "load"
  else
    FlowRouter.go "home"
