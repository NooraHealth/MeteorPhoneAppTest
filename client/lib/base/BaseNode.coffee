class @BaseNode extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @
    console.log "BASE NODE"

  toggleClass: ( domElement, klass )->
    if domElement.hasClass klass
      domElement.removeClass klass
    else
      domElement.addClass klass

  removeNodes: (nodes)->
    for node in nodes
      @.removeChild node
