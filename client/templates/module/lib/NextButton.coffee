

class @NextModuleBtn
  instance = null
  @get: ()=>
    instance ?= new PrivateBtn()

  class PrivateBtn
    
    constructor: ()->
      @.id = "nextbtn"

    getId: ()=>
      return @.id

    show: ()=>
      $("#nextbtn").fadeIn()
      Session.set "next button is hidden", false
      
    shouldHide: ()=>
      currentModule = ModuleSequence.get().getCurrentModule()
      if !currentModule
        return
      if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
        return false
      else
        #return Session.get "next button is hidden"
        return true

    isHidden: ()=>
      return Session.get "next button is hidden"
      


