
###
# Home
# Displays all lessons in curriculum
###
FlowRouter.route '/', {
  action: ( params, qparams )->
    if Scene.get().getCurriculum()
      Scene.get().playAppIntro()
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
    console.log "Going to loading!"
    BlazeLayout.render "layout", { main: "loading" }

