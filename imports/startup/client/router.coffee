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
require '../../ui/pages/home.html'
require '../../ui/pages/home.coffee'

# COMPONENTS
require '../../ui/layouts/layout.html'
require '../../ui/layouts/Content_wrapper.html'
require '../../ui/components/home/footer.html'
require '../../ui/components/home/thumbnail.html'
require '../../ui/components/home/menu/menu.html'
require '../../ui/components/home/menu/list_item.html'
require '../../ui/components/audio/audio.html'

require '../../ui/layouts/layout.coffee'
require '../../ui/components/home/thumbnail.coffee'
require '../../ui/components/home/menu/menu.coffee'
require '../../ui/components/home/menu/list_item.coffee'
require '../../ui/components/audio/audio.coffee'

###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    console.log "Rendering layout"
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

