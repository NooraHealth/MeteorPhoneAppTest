class @BaseNode extends Node
  constructor: ()->
    @.extend Node.prototype
    Node.apply @

  extend: ( mixin )->
    @[name] = method for name, method of mixin

  toggleClass: ( domElement, klass )->
    if domElement.hasClass klass
      domElement.removeClass klass
    else
      domElement.addClass klass

  removeNodes: (nodes)->
    for node in nodes
      @.removeChild node
