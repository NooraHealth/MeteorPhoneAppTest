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
    #console.log CordovaFileServer
    #if Meteor.isCordova
      #scene.setContentSrc CordovaFileServer.httpUrl
    #else
    Scene.get().setContentSrc 'http://noorahealthcontent.noorahealth.org/'
    FlowRouter.initialize()
}


