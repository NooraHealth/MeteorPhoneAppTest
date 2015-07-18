
class @SurfaceFactory
  constructor: (@module)->
    @.surfaceView = @.getModuleSurface module

  getSurfaceView: ()=>
    return @.surfaceView

  getModuleSurface: ()=>
    type = @.module.type

    switch type
      when "SLIDE" then return new SlideSurface @.module
      when "MULTIPLE_CHOICE" then return new MultipleChoiceSurface @.module
      when "BINARY" then return new BinarySurface @.module
      when "VIDEO" then return new VideoSurface @.module
      when "SCENARIO" then return new ScenarioSurface @.module
      else console.log "module type is not within the module types allowed"
