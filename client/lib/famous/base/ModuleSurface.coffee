
class @ModuleSurface extends Node
  constructor: ( @module, @index)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5
     .setPosition 0, 0, @.index

    @.domElement = new DOMElement @,
      properties:
        "background-color": "white"
        "text-align": "center"

    @.positionTransitionable = new Transitionable 1

    @.requestUpdateOnNextTick(@)

  onUpdate: ()=>
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  moveOffstage: ()=>
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500, ()=> console.log "Moved offstage", @
    @.hide()
    @.requestUpdateOnNextTick(@)

  moveOnstage: ()=>
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500, ()=> console.log "Moved onstage", @
    @.show()
    @.requestUpdate(@)

