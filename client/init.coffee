Meteor.startup ()->
  if Meteor.isCordova
    console.log "In the meteor startup and about to initialize the server"
    Meteor.subscribe "users"
    Meteor.subscribe "all_curriculums"
    Meteor.subscribe "all_modules"
    Meteor.subscribe "all_lessons"
    this.initializeServer()
  else
    Meteor.call "contentEndpoint", (err, src)->
      Session.set "content src", src

  console.log famous
  this.FamousEngine = famous.core.FamousEngine
  this.Camera = famous.components.Camera
  this.Node = famous.core.Node
  this.DOMElement = famous.domRenderables.DOMElement

  FamousEngine.init()

  this.Scene = new Scene.get()
