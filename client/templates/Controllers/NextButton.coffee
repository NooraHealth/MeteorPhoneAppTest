

class @NextButton
  @get: ()->
    @.next ?= new PrivateClass()
    return @.next

  class PrivateClass

    _wrapperClasses: ()->
      return ["animate-scale"]

    _buttonClasses: ()->
      return ["slide-up"]

    getElem: ()->
      return $("#next")

    getWrapper: ()->
      return $("#next-button-wrapper")

    changeButtonText: ( text )->
      @getElem().text text

    animate: ()->
      console.log "Animating!!"
      for klass in @._wrapperClasses()
        console.log "Adding " + klass
        if not @getWrapper().hasClass klass
          console.log "Adding " + klass
          @getWrapper().addClass klass

      for klass in @._buttonClasses()
        console.log "Adding " + klass
        if not @getElem().hasClass klass
          console.log "Adding " + klass
          @getElem().addClass klass

    stopAnimation: ()->
      for klass in @._wrapperClasses()
        if @getWrapper().hasClass klass
          @getWrapper().removeClass klass

      for klass in @._buttonClasses()
        if @getElem().hasClass klass
          @getElem().removeClass klass
 


