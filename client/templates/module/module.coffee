###
# MODULES SEQUENCE HELPERS
###

Template.Module.helpers
  modules: ()->
    modules = (module for module in @.modules)
    firstModule = modules[0]
    rearrangedModules = modules.splice(1)
    rearrangedModules.push firstModule
    console.log "rearranged modules", rearrangedModules
    console.log "Template.Data -- ", Template.currentData()
    return rearrangedModules

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Template.Module.onRendered ()->
  fview = FView.from this
  this.autorun ()->
    if isLastModule()
      return
    moduleIndex = Session.get "current module index"
    fview.node._object.show fview.children[moduleIndex].surface
