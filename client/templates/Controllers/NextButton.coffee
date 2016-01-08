

class @NextButton
  @get: ()->
    @.next ?= new PrivateClass()
    return @.next

  class PrivateClass

    constructor: ()->
      @_shakeActionClasses = [ "slide-up", "scale-up", "expanded"]

    getElem: ()->
      return $("#next")

    changeButtonText: ( text )->
      @getElem().text text

    shake: ()->
      console.log "Going to shake the next button"
      for klass in @._shakeActionClasses
        if not @getElem().hasClass klass
          @getElem().addClass klass

    stopShake: ()->
      console.log "Stopping the button from shaking"
      for klass in @._shakeActionClasses
        if @getElem().hasClass klass
          @getElem().removeClass klass
 


