###
# IMPORTS
###
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ FlowRouter } = require 'meteor/kadira:flow-router'
{ TAPi18n } = require("meteor/tap:i18n")
{ AppConfiguration } = require '../../api/AppConfiguration.coffee'

# PAGES
require '../../ui/layouts/layout.coffee'
require '../../ui/pages/select_language.coffee'
require '../../ui/pages/lesson_view.coffee'
require '../../ui/pages/configure.coffee'

if Meteor.isCordova
  require '../../ui/pages/load_curriculums.coffee'

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    hospital = AppConfiguration.getHospital()
    condition = AppConfiguration.getCondition()
    language = AppConfiguration.getLanguage()
    analytics.identify hospital, {
      hospital: hospital,
      condition: condition,
      language: language
    }
    BlazeLayout.render 'Layout', { main : 'Select_language_page' }
}

###
# ConfigureApp
###
FlowRouter.route '/configure', {
  name: "configure"
  action: ( params, qparams )->
    hospital = AppConfiguration.getHospital()
    condition = AppConfiguration.getCondition()
    language = AppConfiguration.getLanguage()
    analytics.identify hospital, {
      hospital: hospital,
      condition: condition,
      language: language
    }
    BlazeLayout.render 'Layout', { main : 'Configure_app_page' }
}

###
# Select Language
###
FlowRouter.route '/lessons', {
  name: "lessons"
  action: ( params, qparams )->

    hospital = AppConfiguration.getHospital()
    condition = AppConfiguration.getCondition()
    language = AppConfiguration.getLanguage()
    analytics.identify hospital, {
      hospital: hospital,
      condition: condition,
      language: language
    }
    BlazeLayout.render 'Layout', { main : 'Lesson_view_page' }
}

###
# Load Curriculums
###
if Meteor.isCordova
  FlowRouter.route '/load', {
    name: "load"
    action: ( params, qparams )->
      hospital = AppConfiguration.getHospital()
      condition = AppConfiguration.getCondition()
      language = AppConfiguration.getLanguage()
      analytics.identify hospital, {
        hospital: hospital,
        condition: condition,
        language: language
      }
      BlazeLayout.render "Layout", { main: "Load_curriculums_page" }
  }
