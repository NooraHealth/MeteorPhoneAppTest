Template.moduleFooter.events
  'click [name=next]': (event, template)->
    console.log "CLICKED NEXT"
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    if moduleSequence.length == currentIndex + 1
      Router.go "chapter", {nh_id: Session.get "current chapter"}
    Session.set "current module index", currentIndex++
    console.log Session.get "current module index"
    console.log Session.get "module sequence"
  

