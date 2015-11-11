
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
FlowRouter.route '/module/:_id', {
  subscriptions: ( params )->
    this.register "all", Meteor.subscribe "all"

  action: ( params, qparams )->
    Session.set "current module id", params._id
    BlazeLayout.render "layout", { main: "modulesSequence" , footer: "moduleFooter1" }
}

FlowRouter.route '/loading',
  action: ()->
    BlazeLayout.render "layout", { main: "loading" }


