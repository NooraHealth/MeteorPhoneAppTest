class @ResponseButton extends Node
  constructor: (@value)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.sizeTransitionable = new Transitionable .5

    @.addUIEvent "click"

  onUpdate: ()=>
    x = .75 * @.sizeTransitionable.get() + .75
    y = .75 * @.sizeTransitionable.get() + .75
    @.setScale x, y, 1

  respond: (type)=>
    @.sizeTransitionable.halt()
    if type == "CORRECT"
      @.sizeTransitionable.to 1, "easeIn", 1000, ()-> console.log "Scaled up"
    if type == "INCORRECT"
      @.sizeTransitionable.to 0, "easeOut", 1000, ()-> console.log "Scaled down"

    @.requestUpdate @
      



