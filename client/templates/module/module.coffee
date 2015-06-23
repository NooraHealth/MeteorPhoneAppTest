###
# MODULES SEQUENCE HELPERS
###

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
  console.log "Rendering"
  fview = FView.from this
  fview.node._object.hide()
  console.log fview
  Session.set "next button is hidden", nextBtnShouldHide()

  this.autorun ()->
    moduleIndex = Session.get "current module index"
    nh_id = Session.get("modules sequence")[moduleIndex].nh_id
    surface = FView.byId nh_id
    fview.node._object.show surface
    #Session.set "next button is hidden", nextBtnShouldHide()

