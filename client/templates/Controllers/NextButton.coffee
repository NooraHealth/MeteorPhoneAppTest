

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
      for klass in @._wrapperClasses()
        if not @getWrapper().hasClass klass
          @getWrapper().addClass klass

      for klass in @._buttonClasses()
        if not @getElem().hasClass klass
          @getElem().addClass klass

    stopAnimation: ()->
      for klass in @._wrapperClasses()
        if @getWrapper().hasClass klass
          @getWrapper().removeClass klass

      for klass in @._buttonClasses()
        if @getElem().hasClass klass
          @getElem().removeClass klass
 


