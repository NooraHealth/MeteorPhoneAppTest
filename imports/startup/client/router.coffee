###
# IMPORTS
###
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ FlowRouter } = require 'meteor/kadira:flow-router'

# PAGES
require '../../ui/layouts/layout.coffee'
require '../../ui/pages/home.coffee'
require '../../ui/pages/lesson_view.coffee'

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    console.log "Going to the home page"
    BlazeLayout.render 'Layout', { main : 'Home_page' }
}

###
# module sequence
###

FlowRouter.route '/lesson/:_id', {
  name: "lesson"
  action: ( params, qparams )->
    console.log "Going to the lessons page"
    BlazeLayout.render "Layout", { main: "Lesson_view_page" }

}

