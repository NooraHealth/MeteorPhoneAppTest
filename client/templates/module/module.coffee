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
   #restOfDocs: ()->
    #rest = (module for module, index in @.modules when index != 0)
    #return rest

  #firstModule: ()->
    #return @.modules[0]

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Template.module.onRendered ()->
  fview = FView.from this
  console.log fview
  fview.node._object.hide()

  this.autorun ()->
    moduleIndex = Session.get "current module index"
    #console.log "what is the module index? ", moduleIndex
    nh_id = Session.get("modules sequence")[moduleIndex].nh_id
    #console.log "What is the nh_id ?", nh_id
    surface = FView.byId nh_id
    fview.node._object.show surface
    #console.log "SURAFEc", surface
    #console.log "This is the renderController", fview
    #console.log "TEST SURFACE: ", FView.byId "1000170"
    #console.log "TEST SURFACE 2: " , FView.byId "1000156"
    lastModule = fview.children[fview.children.length-2]
    #console.log "lastModule: ", lastModule
    #fview.node._object.show lastModule
    #fview.node._object.show surface

