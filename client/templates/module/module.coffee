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
  children = fview.children
  eventHandlers = []
  #fview.node._object.show fview.children[1].surface
  
  this.autorun ()->
    if isLastModule()
      return
    moduleIndex = Session.get "current module index"
    fview.node._object.show fview.children[moduleIndex + 1].surface
    events.emit "yourTurn", fview.children[moduleIndex+1].surface
    modules = Template.currentData().modules
    playAudio "question", modules[moduleIndex]

  this.autorun ()->
    #moduleIndex = Session.get "current module index"
    #playAudio "question", modules[moduleIndex]


Template.multipleChoiceModule.onRendered ()->
  fview = FView.from this
  console.log "MC RENDERED"
  console.log fview

Template.slideModule.onRendered ()->
  fview = FView.from this
  console.log "SLIDE RENDERED"
  console.log fview

