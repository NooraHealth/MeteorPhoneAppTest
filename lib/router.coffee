  
  ###
  # Home
  # Displays all lessons in curriculum
  ###
  FlowRouter.route '/', {
    action: ( params, qparams )->
      console.log "!!!!"
      console.log "In the route@"
      console.log "!!!!"
      scene = Scene.get()
      if not scene.curriculumIsSet()
        scene.openCurriculumMenu()
      BlazeLayout.render "layout", { main : "lessonsView" }

  }

  ###
  # module sequence
  ###
  FlowRouter.route '/module/:_id', {
    action: ( params, qparams )->
      Session.set "current module id", params._id
      BlazeLayout.render "layout", { main: "modulesSequence" , footer: "moduleFooter1" }
  }

  FlowRouter.route '/loading',
    action: ()->
      BlazeLayout.render "layout", { main: "loading" }


