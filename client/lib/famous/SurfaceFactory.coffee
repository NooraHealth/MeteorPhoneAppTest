
class @SurfaceFactory
  @get: ()->
    @.factory ?= new PrivateFactory()
    return @.factory

  class PrivateFactory
    
    getModuleSurface: (module, index)=>
      type = module.type

      switch type
        when "SLIDE" then return new SlideSurface module, index
        when "MULTIPLE_CHOICE" then return new MultipleChoiceSurface module, index
        when "BINARY" then return new BinarySurface module, index
        when "VIDEO" then return new VideoSurface module, index
        when "SCENARIO" then return new ScenarioSurface module, index
        else console.log "module type is not within the module types allowed"
