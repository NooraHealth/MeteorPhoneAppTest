FlowRouter.wait()

this.FamousEngine = famous.core.FamousEngine
this.Camera = famous.components.Camera
this.Node = famous.core.Node
this.Scale = famous.components.Scale
this.DOMElement = famous.domRenderables.DOMElement
this.Transitionable = famous.transitions.Transitionable

FamousEngine.init()

console.log "ABOUT TO SUBSCRIBE"
Meteor.subscribe "all", {
  onReady: ()->
    #endpoint = 'http://noorahealthcontent.noorahealth.org/'
    endpoint = "http://noorahealthcontent.noorahealth.org.s3-website-us-west-1.amazonaws.com/"
    console.log "SUBSCRIBED"
    if Meteor.isCordova
      Scene.get().setContentSrc CordovaFileServer.httpUrl
    else
      Scene.get().setContentSrc endpoint
    Scene.get().setContentEndpoint endpoint
    FlowRouter.initialize()
}


