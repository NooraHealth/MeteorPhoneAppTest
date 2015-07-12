
Template.module.rendered =  ()=>
  @.moduleSurfaces = []
  #fview.node._object.hide()
  hidden =  nextBtnShouldHide()
  Session.set "next button is hidden", hidden
  #lightbox controller
  lightbox = FView.byId "lightbox"
  console.log "LIGHTBOX"
  console.log lightbox
  #t = Transform.translate(-600, 0, 0), {duration: 1000, curve: "easeIn"}
  #o = Transform.translate(600, 0, 0), {duration: 1000, curve: "easeOut"}

  console.log SpringTransition()
  console.log new SpringTransition()
  transition = {duration: 1000, curve: "easeIn"}

  modules = Template.currentData().modules
  @.moduleView = new ModuleView(modules)

  eventInput = new EventHandler()
  subscribeLightboxToFooterEvents( lightbox, eventInput )
  eventInput.on "showModule", ( index )=>
    @.moduleView.show index

  #create the surfaces
  @.moduleView.show 0

subscribeLightboxToFooterEvents = ( lightbox, eventInput )->
  EventHandler.setInputHandler lightbox, eventInput
  
  #get the next btn's view and event handler
  nextBtnFview = FView.byId "footer"
  nextBtnSurface = nextBtnFview.view or nextBtnFview.surface
  nextBtnEventOutput = nextBtnSurface._eventOutput

  #subscribe the lightbox to the next btn footer's events
  eventInput.subscribe nextBtnEventOutput

