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
    return rearrangedModules

  
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

  #eventInput.on "showModule", (id)->
    #console.log "Showing the module"
    #surface = FView.byId id
    #lightbox.node._object.show surface


  #create the surfaces
  modules = Template.currentData().modules

  module = modules[0]
  surface = new Surface {
    content: Blaze.toHTMLWithData(Template.slideModule, module)
    size: [100,100]
  }
  lightbox.node._object.show surface
