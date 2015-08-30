class @ResponseButton extends Node
  constructor: (@value)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.domElement = ResponseButton.getButtonDomElement(@)

    @.sizeTransitionable = new Transitionable .5
    @.enable()

  @getButtonDomElement: ( node )->
    elem = new DOMElement node,
      tagName: "a"
      properties:
        "border-radius": "5px"

    elem.addClass "waves-light"
    elem.addClass "waves-effect"
    elem.addClass "white-text"
    elem.addClass "flow-text"
    elem.addClass "center-align"
    elem.addClass "btn"
    return elem

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
      



