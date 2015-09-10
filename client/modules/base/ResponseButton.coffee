class @ResponseButton extends BaseNode
  constructor: (@value)->
    super

    @.domElement = ResponseButton.getButtonDomElement(@)

    @.sizeTransitionable = new Transitionable .5
    @.addUIEvent "click"

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

  reset: ()->
    @.sizeTransitionable.to .5

  onUpdate: ()=>
    x = .5 * @.sizeTransitionable.get() + .75
    y = .5 * @.sizeTransitionable.get() + .75
    @.setScale x, y, 1

  respond: (type)=>
    @.sizeTransitionable.halt()
    if type == "CORRECT"
      @.sizeTransitionable.to 1, "easeIn", 1000, ()-> console.log "Scaled up"
    if type == "INCORRECT"
      @.sizeTransitionable.to 0, "easeOut", 1000, ()-> console.log "Scaled down"

    @.requestUpdate @
      



