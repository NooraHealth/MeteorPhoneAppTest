###
# MODULES SEQUENCE HELPERS
###

Template.module.helpers

  rearrangedModules: ()->
    modules = (module for module in @.modules)
    firstModule = modules[0]
    rearrangedModules = modules.splice(1)
    rearrangedModules.push {_id: "dummyModule", type:"dummy"}
    rearrangedModules.push firstModule
    console.log "REARRAd=_id NGED: ", rearrangedModules
    return modules
  
  dummyModule: ()->
    return @.type == "dummy"

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Template.module.rendered =  ()->
  #fview.node._object.hide()
  hidden =  nextBtnShouldHide()
  Session.set "next button is hidden", hidden
  #lightbox controller
  lightbox = FView.byId "lightbox"
  eventInput = new EventHandler()
  EventHandler.setInputHandler lightbox, eventInput
  console.log lightbox
  
  #get the next btn's view and event handler
  nextBtnFview = FView.byId "footer"
  nextBtnSurface = nextBtnFview.view or nextBtnFview.surface
  nextBtnEventOutput = nextBtnSurface._eventOutput

  #subscribe the lightbox to the next btn footer's events
  eventInput.subscribe nextBtnEventOutput

  eventInput.on "showModule", (id)->
    moduleIndex = Session.get "current module index"
    _id = Session.get("modules sequence")[moduleIndex]._id
    console.log "This is the id", id
    console.log _id
    surface = FView.byId _id
    console.log "This is the surface to show"
    console.log surface
    lightbox.node._object.show surface

  this.autorun ()->
    #Session.set "next button is hidden", nextBtnShouldHide()

