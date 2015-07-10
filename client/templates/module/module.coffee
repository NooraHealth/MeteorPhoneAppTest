
Template.module.rendered =  ()=>
  @.moduleSurfaces = []
  #fview.node._object.hide()
  hidden =  nextBtnShouldHide()
  Session.set "next button is hidden", hidden
  #lightbox controller
  lightbox = FView.byId "lightbox"
  eventInput = new EventHandler()
  EventHandler.setInputHandler lightbox, eventInput
  
  #get the next btn's view and event handler
  nextBtnFview = FView.byId "footer"
  nextBtnSurface = nextBtnFview.view or nextBtnFview.surface
  nextBtnEventOutput = nextBtnSurface._eventOutput

  #subscribe the lightbox to the next btn footer's events
  eventInput.subscribe nextBtnEventOutput

  modules = Template.currentData().modules
  @.moduleView = new ModuleView(modules)

  eventInput.on "showModule", (index)=>
    @.moduleView.show index

  #create the surfaces
  @.moduleView.show 0

