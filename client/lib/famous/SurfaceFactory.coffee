
class @SurfaceFactory
  @get: ()->
    @.factory ?= new PrivateFactory()
    return @.factory

  class PrivateFactory
    
    getModuleSurface: (module)=>
      console.log "Getting the module surface"
      console.log module
      type = module.type

      switch type
        when "SLIDE" then return new SlideSurface module
        when "MULTIPLE_CHOICE" then return new MultipleChoiceSurface module
        when "BINARY" then return new BinarySurface module
        when "VIDEO" then return new VideoSurface module
        when "SCENARIO" then return new ScenarioSurface module
        else console.log "module type is not within the module types allowed"
