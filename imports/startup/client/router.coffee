###
# IMPORTS
###
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ FlowRouter } = require 'meteor/kadira:flow-router'

# LIBRARIES
require '../../api/lib.coffee'

# CSS
#require '../../ui/style/scss/shared/shared.scss'
#require '../../ui/style/scss/lessons/lessons.scss'
#require '../../ui/style/scss/home/home.scss'

# PAGES
require '../../ui/pages/home.coffee'

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

#FlowRouter.route '/lesson/:_id', {
  #name: "lesson"
  #action: ( params, qparams )->
    #BlazeLayout.render "moduleLayout", { main: "moduleSlider", footer: "moduleFooter" }

#}

#FlowRouter.route '/loading',
  #name: "loading"
  #action: ()->
    #console.log "In the loading router"
    #BlazeLayout.render "layout", { main: "loading" }

