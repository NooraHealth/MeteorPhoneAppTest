class @ResponseButton extends Node
  constructor: (@value)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.domElement = new DOMElement @,
      tagName: "a"
      properties:
        "text-align": "center"
        "border-radius": "10px"
        "margin": "5px"

    @.domElement.addClass "waves-light"
    @.domElement.addClass "waves-effect"
    @.domElement.addClass "white-text"
    @.domElement.addClass "flow-text"

    @.sizeTransitionable = new Transitionable .5
    @.enable()

  disable: ()=>
    @.disabled = true
    @.removeUIEvent "click"
    if @.domElement
      @.domElement.addClass "faded"

  enable: ()=>
    @.disabled = false
    @.addUIEvent "click"
    if @.domElement
      @.domElement.setProperty "opacity": ".5"

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
      



