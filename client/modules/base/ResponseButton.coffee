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
    x = .4 * @.sizeTransitionable.get() + .8
    y = .4 * @.sizeTransitionable.get() + .8
    @.setScale x, y
    
  respond: (type)=>
    @.sizeTransitionable.halt()
    console.log @.getPosition()
    console.log @.getOrigin()

    if type == "CORRECT"
      @.sizeTransitionable.to 1, "easeIn", 500
    if type == "INCORRECT"
      @.sizeTransitionable.to 0, "easeOut", 500

    @.requestUpdate @
      



