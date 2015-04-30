###
# MODULES SEQUENCE HELPERS
###

Template.Module.helpers
  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Template.Module.onRendered ()->
  console.log "MODULE RENDERED"
  fview = FView.from this
  events = new EventHandler()
  surfaces = (child.surface for child in fview.children.splice(1))
  eventHandlers = []
  for surface in surfaces
    console.log "surface"
    handler = new EventHandler()
    eventHandlers.push handler
    handler.subscribe events
    handler.on "yourTurn", ()->
      console.log "MY TURN!"
    console.log handler
  console.log surfaces

  #fview.node._object.show fview.children[1].surface
  
  this.autorun ()->
    moduleIndex = Session.get "current module index"
    #fview.node._object.show fview.children[moduleIndex + 1].surface
    events.emit "yourTurn"

  this.autorun ()->
    moduleIndex = Session.get "current module index"
    modules = Template.currentData().modules
    #playAudio "question", modules[moduleIndex]


Template.multipleChoiceModule.onRendered ()->
  fview = FView.from this
  console.log "MC RENDERED"
  console.log fview

Template.slideModule.onRendered ()->
  fview = FView.from this
  console.log "SLIDE RENDERED"
  console.log fview

