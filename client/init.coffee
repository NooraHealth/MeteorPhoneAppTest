FlowRouter.wait()

Meteor.startup ()->

  console.log "calling FlowRouter.wait()"

  this.FamousEngine = famous.core.FamousEngine
  this.Camera = famous.components.Camera
  this.Node = famous.core.Node
  this.DOMElement = famous.domRenderables.DOMElement
  this.Transitionable = famous.transitions.Transitionable

  FamousEngine.init()
  scene = Scene.get()
  Meteor.subscribe "users"
  Meteor.subscribe "all_curriculums"
  Meteor.subscribe "all_modules"
  Meteor.subscribe "all_lessons"

  if Meteor.isCordova
    scene.setContentSrc 'http://127.0.0.1:8080/'
  else
    scene.setContentSrc 'http://noorahealthcontent.noorahealth.org/'

  FlowRouter.initialize()
