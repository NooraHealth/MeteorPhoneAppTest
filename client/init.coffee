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
    #console.log CordovaFileServer
    #if Meteor.isCordova
      #scene.setContentSrc CordovaFileServer.httpUrl
    #else
    scene.setContentSrc 'http://noorahealthcontent.noorahealth.org/'
    console.log "Is there a cordova file server?"
}


