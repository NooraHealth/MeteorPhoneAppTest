
###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  name: "home"
  action: ( params, qparams )->
    BlazeLayout.render "layout", { main : "lessonsView" }
}

###
# module sequence
###

FlowRouter.route '/module/:_id', {
  name: "module"
  triggersExit: [ ( context, redirect ) ->
    console.log "CONTEXT"
    console.log context
    $(".module-card").removeClass "offscreen-left"
    $(".module-card").addClass "offscreen-right"
    console.log $(".module-card")
  ]
  action: ( params, qparams )->
    module = Modules.findOne { _id: params._id }
    console.log Modules.find({}).count()
    console.log module
    console.log params._id
    if module.type == "BINARY"
      template = "binaryChoiceModule"
    if module.type == "MULTIPLE_CHOICE"
      template = "multipleChoiceModule"
    if module.type == "SCENARIO"
      template = "scenarioModule"
    if module.type == "VIDEO"
      template = "videoModule"
    if module.type == "SLIDE"
      template = "slideModule"
    BlazeLayout.render "moduleLayout", { main: template , footer: "moduleFooter" }
}

FlowRouter.route '/loading',
  name: "loading"
  action: ()->
    BlazeLayout.render "layout", { main: "loading" }

