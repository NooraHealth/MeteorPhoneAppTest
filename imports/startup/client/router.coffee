###
# IMPORTS
###
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ FlowRouter } = require 'meteor/kadira:flow-router'

# LIBRARIES
require '../../api/lib.coffee'

# PAGES
require '../../ui/pages/home.coffee'
require '../../ui/pages/lesson_view.coffee'

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    BlazeLayout.render 'layout', { main : 'Home_page' }
}

###
# module sequence
###

FlowRouter.route '/lesson/:_id', {
  name: "lessonView"
  action: ( params, qparams )->
    BlazeLayout.render "layout", { main: "Lesson_view_page" }

}

#FlowRouter.route '/loading',
  #name: "loading"
  #action: ()->
    #console.log "In the loading router"
    #BlazeLayout.render "layout", { main: "loading" }

