###
# IMPORTS
###
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ FlowRouter } = require 'meteor/kadira:flow-router'
{ AppState } = require '../../api/AppState.coffee'

# PAGES
require '../../ui/layouts/layout.coffee'
require '../../ui/pages/home.coffee'
require '../../ui/pages/lesson_view.coffee'

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
    if not AppState.get().isConfigured()
      BlazeLayout.render 'Layout', { main : 'Configure_app_page' }
    else
      AppState.get().setLoading false
      BlazeLayout.render 'Layout', { main : 'Home_page' }
}

###
# Go through the modules in a lesson
###
FlowRouter.route '/lesson/:_id', {
  name: "lesson"
  action: ( params, qparams )->
    console.log "Going to the lessons page"
    BlazeLayout.render "Layout", { main: "Lesson_view_page" }

}

###
# Load Curriculums
###
if Meteor.isCordova
  FlowRouter.route 'load', {
    name: "loadCurriculums"
    action: ( params, qparams )->
      console.log "Going to the load curriculums page"
      BlazeLayout.render "Layout", { main: "Load_curriculums_page" }
  }
