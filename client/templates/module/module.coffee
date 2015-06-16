###
# MODULES SEQUENCE HELPERS
###

Template.slide.helpers

  outerWrapperClasses: ()->
    return "valign-wrapper module row"

  innerWrapperClasses: ()->
    return "valign module-wrapper col l4 offset-l4 m6 offset-m3"

Template.module.helpers

  rearrangedModules: ()->
    modules = (module for module in @.modules)
    firstModule = modules[0]
    rearrangedModules = modules.splice(1)
    rearrangedModules.push {nh_id: "dummyModule", type:"dummy"}
    rearrangedModules.push firstModule
    console.log "REARRAd=nh_id NGED: ", rearrangedModules
    return rearrangedModules
  
  dummyModule: ()->
    return @.type == "dummy"

#imgSrc: ()->
    #return Session.get "media url" + @.image

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Template.module.onRendered ()->
  fview = FView.from this
  fview.node._object.hide()

  this.autorun ()->
    moduleIndex = Session.get "current module index"
    nh_id = Session.get("modules sequence")[moduleIndex].nh_id
    surface = FView.byId nh_id
    fview.node._object.show surface

