
###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  subscriptions: ( params )->
    this.register "all", Meteor.subscribe "all"

  action: ( params, qparams )->
    console.log "!!!!"
    console.log "In the route@"
    console.log "!!!!"
    BlazeLayout.render "layout", { main : "lessonsView" }
}

###
# module sequence
###

FlowRouter.route '/modules/:_id', {
  subscriptions: ( params )->
    this.register "all", Meteor.subscribe "all"

  action: ( params, qparams )->
    BlazeLayout.render "layout", { main: "modulesSequence" , footer: "moduleFooter1" }
}

FlowRouter.route '/loading',
  action: ()->
    BlazeLayout.render "layout", { main: "loading" }

