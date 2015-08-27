
class @ModuleSurface extends Node
  constructor: ( @module, @index)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.size ?= [700, 600]
    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     #.setProportionalSize .8, .7, 1
     .setAbsoluteSize 600, 500, 0
     .setPosition 0, 0, @.index

    @.positionTransitionable = new Transitionable 1

    @.requestUpdate(@)

  onUpdate: ()->
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  moveOffstage: ()->
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500, ()-> console.log "Moved offstage"
    @.hide()
    @.requestUpdateOnNextTick(@)

  moveOnstage: ()->
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500, ()-> console.log "Moved onstage"
    @.requestUpdateOnNextTick(@)




