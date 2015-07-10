Template.module_layout.helpers
  firstModule: ()->
    console.log "Getting the firstmodule"
    console.log @.modules
    if !@.modules
      return
    module = @.modules[0]
    console.log "returning first module"
    return @.modules[0]

Template.layout.helpers {
  getTransition: ()->
    return Session.get "current transition"
}
