Template.moduleFooter.helpers
#  isLastModule: ()->
    #console.log isLastModule()
    #console.log "getting last module"
    #return isLastModule()
  
Template.moduleFooter.events
  'click [name=next]': (event, template)->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"

    if isLastModule()
      Router.go "chapter", {nh_id: Session.get "current chapter"}
    else
      Session.set "current module index", currentIndex++
