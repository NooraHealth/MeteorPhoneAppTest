
###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  action: ( params, qparams )->
    console.log "Loading home"
    BlazeLayout.render "layout", { main : "lessonsView" }
}

###
# module sequence
###

FlowRouter.route '/modules/:_id', {
  action: ( params, qparams )->
    Scene.get().stopAudio()
    BlazeLayout.render "layout", { main: "modulesSequence" , footer: "moduleFooter1" }
}

FlowRouter.route '/loading',
  action: ()->
    BlazeLayout.render "layout", { main: "loading" }

