

class @NextButton
  @get: ()->
    @.next ?= new PrivateClass()
    return @.next

  class PrivateClass

    constructor: ()->
      @_shakeActionClasses = [ "slide-up", "scale-up", "expanded"]
      @_elem = $("#next")

    changeButtonText: ( text )->
      @_elem.text text

    shake: ()->
      for klass in @._shakeActionClasses
        if not @_elem.hasClass klass
          @_elem.addClass klass

    stopShake: ()->
      for klass in @._shakeActionClasses
        if @_elem.hasClass klass
          @_elem.removeClass klass
 


