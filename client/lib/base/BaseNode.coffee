class @BaseNode extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

  removeAllChildren: ()->
    for child in @.getChildren()
      @.removeChild child
