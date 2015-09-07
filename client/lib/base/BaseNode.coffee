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

  #a temporary hackaround for the famous
  #removeChild bug
  removeAllChildren: ()=>
    children = @.getChildren()
    copies = []
    for child in children
      if child.removeAllChildren
        child.removeAllChildren()
      copies.push child

    for child in copies
      @.removeChild child

