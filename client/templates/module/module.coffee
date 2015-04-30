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
  for child in children
    if child.surface
      handler = new EventHandler()
      eventHandlers.push handler
      handler.subscribe events
      console.log child.surface
      handler.on "yourTurn", (s)->
        console.log ""
        console.log "s"
        console.log s
        console.log child.surface
        console.log child.surface ==s
        console.log ""
      console.log handler

  #fview.node._object.show fview.children[1].surface
  
  this.autorun ()->
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

