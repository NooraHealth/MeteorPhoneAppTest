
class @ControllerFactory
  @get: ()->
    @.factory ?= new PrivateFactory()
    return @.factory

  class PrivateFactory
    
    getModuleController: ( module )=>
      type = module.type

      switch type
        when "SLIDE" then surface = new SlideController module
        when "MULTIPLE_CHOICE" then surface = new MultipleChoiceController module
        when "BINARY" then surface = new SingleAnswerQuestion module
        when "VIDEO" then surface = new VideoController module
        when "SCENARIO" then surface = new SingleAnswerQuestion module
        else console.log "module type is not within the module types allowed"

