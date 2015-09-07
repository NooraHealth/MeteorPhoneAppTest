
class @SurfaceFactory
  @get: ()->
    @.factory ?= new PrivateFactory()
    return @.factory

  class PrivateFactory
    
    getModuleSurface: ( module, parent)=>
      type = module.type

      switch type
        when "SLIDE" then surface = SlideSurface.get module, parent
        when "MULTIPLE_CHOICE" then surface = MultipleChoiceSurface.get module, parent
        when "BINARY" then surface = BinarySurface.get module, parent
        when "VIDEO" then surface = VideoSurface.get module, parent
        when "SCENARIO" then surface = ScenarioSurface.get module, parent
        else console.log "module type is not within the module types allowed"

