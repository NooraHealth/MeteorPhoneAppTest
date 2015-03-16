  
Template.moduleFooter.events
  'click [name=next]': (event, template)->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "current module index", ++currentIndex
    console.log "Set the current module index", Session.get "current module index"
    
  'click [name=finish]': (event, template) ->
    Router.go "chapter", {nh_id: Session.get "current chapter"}
