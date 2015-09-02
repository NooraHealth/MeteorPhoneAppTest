class @BaseNode
  constructor: ()->
    @.extend Node

  extend: ( mixin )=>
    @[name] = method for name, method of mixin.prototype
    mixin.apply @

  toggleClass: ( domElement, klass )->
    if domElement.hasClass klass
      domElement.removeClass klass
    else
      domElement.addClass klass

  removeNodes: (nodes)->
    for node in nodes
      @.removeChild node
