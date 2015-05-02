###
# MODULES SEQUENCE HELPERS
###

Template.Module.helpers
  modules: ()->
    modules = (module for module in @.modules)
    firstModule = modules[0]
    rearrangedModules = modules.splice(1)
    rearrangedModules.push firstModule
    return rearrangedModules

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]
  getId: ()->
    return @.nh_id

Template.Module.onRendered ()->
  fview = FView.from this
  this.autorun ()->
    if isLastModule()
      return
    moduleIndex = Session.get "current module index"
    nh_id = Session.get("modules sequence")[moduleIndex].nh_id
    surface = FView.byId nh_id
    console.log "surface"
    console.log surface
    fview.node._object.show surface

