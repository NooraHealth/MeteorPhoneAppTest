
class @ModuleSurface extends Node
  constructor: ( @module, @index)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.size ?= [700, 600]
    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, .8, 1
     #.setAbsoluteSize 700, 600, 0
     .setPosition 0, 0, @.index

    @.positionTransitionable = new Transitionable 1
    FamousEngine.requestUpdate(@)

    @.domElement = new DOMElement @, {
      properties:
        "background-color": "green"
    }

  onUpdate: ()->
    console.log "Updating the position"
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0
    console.log @.getPosition()

  moveOffstage: ()->
    console.log "About to move offstage"
    console.log @
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500, ()-> console.log "Moved offstage"
    @.hide()
    @.requestUpdate(@)

  moveOnstage: ()->
    console.log "About to move onstage"
    console.log @
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500, ()-> console.log "Moved onstage"
    @.requestUpdate(@)




