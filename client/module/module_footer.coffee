  
Template.moduleFooter.events
  'click [name=next]': (event, template)->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "previous module index", currentIndex
    Session.set "current module index", ++currentIndex

  'click [name=previous]': ()->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "previous module index", currentIndex
    Session.set "current module index", --currentIndex
  
  'click [name=return_to_chapter]': ()->
    Router.go "chapter", {nh_id: Session.get "current chapter"}
    
  'click [name=finish]': (event, template) ->
    Router.go "chapter", {nh_id: Session.get "current chapter"}
