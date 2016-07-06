###
# IMPORTS
###
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ FlowRouter } = require 'meteor/kadira:flow-router'
{ AppState } = require '../../api/AppState.coffee'

# PAGES
require '../../ui/layouts/layout.coffee'
require '../../ui/pages/home.coffee'
require '../../ui/pages/select_language.coffee'
require '../../ui/pages/lesson_view.coffee'
#require '../../ui/pages/wrapper_page.coffee'

if Meteor.isCordova
  require '../../ui/pages/load_curriculums.coffee'
  require '../../ui/pages/configure.coffee'

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    console.log "In the route for home"
    if not AppState.get().isConfigured()
      BlazeLayout.render 'Layout', { main : 'Configure_app_page' }
    else
      hospital = AppState.get().getHospital()
      condition = AppState.get().getCondition()
      language = AppState.get().getLanguage()
      analytics.identify hospital, {
        hospital: hospital,
        condition: condition,
        language: language
      }
      BlazeLayout.render 'Layout', { main : 'Select_language_page' }
}

###
# Go through the modules in a lesson
###
#FlowRouter.route '/lesson/:_id', {
FlowRouter.route '/lessons', {
  name: "lessons"
  action: ( params, qparams )->
    hospital = AppState.get().getHospital()
    condition = AppState.get().getCondition()
    language = AppState.get().getLanguage()
    analytics.identify hospital, {
      hospital: hospital,
      condition: condition,
      language: language
    }
    console.log "Going to the lessons page"
    BlazeLayout.render "Layout", { main: "Lesson_view_page" }

}

###
# Load Curriculums
###
if Meteor.isCordova
  FlowRouter.route '/load', {
    name: "load"
    action: ( params, qparams )->
      hospital = AppState.get().getHospital()
      condition = AppState.get().getCondition()
      language = AppState.get().getLanguage()
      analytics.identify hospital, {
        hospital: hospital,
        condition: condition,
        language: language
      }
      console.log "Going to the load curriculums page"
      BlazeLayout.render "Layout", { main: "Load_curriculums_page" }
  }
