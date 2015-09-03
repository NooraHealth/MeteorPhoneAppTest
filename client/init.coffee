FlowRouter.wait()

this.FamousEngine = famous.core.FamousEngine
this.Camera = famous.components.Camera
this.Node = famous.core.Node
this.Scale = famous.components.Scale
this.DOMElement = famous.domRenderables.DOMElement
this.Transitionable = famous.transitions.Transitionable

FamousEngine.init()

Meteor.subscribe "all", {
  onReady: ()->
    scene = Scene.init()
    #if Meteor.isCordova
      #scene.setContentSrc 'http://127.0.0.1:8080/'
    #else
      #scene.setContentSrc 'http://noorahealthcontent.noorahealth.org/'
    scene.setContentSrc 'http://noorahealthcontent.noorahealth.org/'
    scene.openCurriculumMenu()
}


