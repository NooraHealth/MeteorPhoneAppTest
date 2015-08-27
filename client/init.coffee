Meteor.startup ()->
  this.FamousEngine = famous.core.FamousEngine
  this.Camera = famous.components.Camera
  this.Node = famous.core.Node
  this.DOMElement = famous.domRenderables.DOMElement

  FamousEngine.init()
  scene = Scene.get()

  if Meteor.isCordova
    console.log "In the meteor startup and about to initialize the server"
    Meteor.subscribe "users"
    Meteor.subscribe "all_curriculums"
    Meteor.subscribe "all_modules"
    Meteor.subscribe "all_lessons"

    scene.setContentSrc 'http://127.0.0.1:8080/'

  else
    scene.setContentSrc 'http://noorahealthcontent.noorahealth.org/'
