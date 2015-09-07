
###
# Scenario Surface
###
class @ScenarioSurface
  @get: ( module, parent )->
    if not @.surface
      @.surface = new PrivateSurface module
      parent.addChild @.surface
    else
      @.surface.setModule module

    return @.surface

  class PrivateSurface extends ModuleSurface

    constructor: (@module)->
      super( @.module )
      @.extend BasicQuestion

      @.TITLE_HEIGHT = 60
      @.SIZE = [800, 500]
      @.setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
      #.setProportionalSize .8, .8, 1
      .setAbsoluteSize @.SIZE[0], @.SIZE[1]
      
      @.domElement.addClass "card"

      @.image = new ModuleImage(@.module)

      @.title = new TitleBar(@.module.question, { x: @.SIZE[0], y: @.TITLE_HEIGHT})
      @.normal = new NormalBtn("Normal")
      @.callDoc = new CallDocBtn("CallDoc")
      @.emergency = new EmergencyBtn("Call911")

      @.addChild @.image
      @.addChild @.title
      @.addChild @.normal
      @.addChild @.callDoc
      @.addChild @.emergency

      @.buttons = [ @.normal, @.callDoc, @.emergency ]
      for button in @.buttons
        button.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
        button.setProportionalSize .27, .075

  class NormalBtn extends ResponseButton
    constructor: (@value)->
      super @.value

      @.setOrigin .5, .5, .5
      .setAlign .03, .9, .5
      .setMountPoint 0, 1, .5

      @.domElement.addClass "green"
      @.domElement.setContent "Normal"

  class CallDocBtn extends ResponseButton
    constructor: (@value)->
      super @.value

      @.setOrigin .5, .5, .5
      .setAlign .5, .9, .5
      .setMountPoint .5, 1, .5

      @.domElement.addClass "yellow"
      @.domElement.setContent "Call Doctor"

  class EmergencyBtn extends ResponseButton
    constructor: (@value)->
      super @.value

      @.setOrigin .5, .5, .5
      .setAlign .97, .9, .5
      .setMountPoint 1, 1, .5

      @.domElement.addClass "red"
      @.domElement.setContent "Call 911"

