###
# MODULES SEQUENCE HELPERS
###

Template.module.helpers
  restOfDocs: ()->
    rest = (module for module, index in @.modules when index != 0)
    console.log "These are the rest!", rest
    return rest

  firstModule: ()->
    return @.modules[0]

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]
  
  getId: ()->
    console.log @
    console.log "GETTING THE ID: ", @.nh_id
    return @.nh_id

Template.module.onRendered ()->
  fview = FView.from this

  this.autorun ()->
    moduleIndex = Session.get "current module index"
    console.log "what is the module index? ", moduleIndex
    nh_id = Session.get("modules sequence")[moduleIndex].nh_id
    console.log "What is the nh_id ?", nh_id
    surface = FView.byId nh_id
    console.log "SURAFEc", surface
    console.log "This is the renderController", fview
    console.log "TEST SURFACE: ", FView.byId "1000170"
    console.log "TEST SURFACE 2: " , FView.byId "1000156"
    fview.node._object.show surface

