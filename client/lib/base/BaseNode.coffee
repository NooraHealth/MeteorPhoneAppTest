class @BaseNode extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @
    console.log "BASE NODE"

  removeNodes: (nodes)->
    for node in nodes
      @.removeChild node
