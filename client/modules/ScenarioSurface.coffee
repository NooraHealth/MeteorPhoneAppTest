
###
# Scenario Surface
###
class @ScenarioSurface extends ModuleSurface
  constructor: (@module, index)->
    @.size = [800, 600]
    super( @.module , index, @.size)
    @.extend BasicQuestion.prototype
    BasicQuestion.apply @
    
    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, 1, 1

    @.domElement.addClass "card"

    @.image = new ModuleImage(@.module)
    @.normal = new NormalBtn("Normal")
    @.callDoc = new CallDocBtn("CallDoc")
    @.emergency = new CallDocBtn("Call911")

    @.addChild @.image
    @.addChild @.normal
    @.addChild @.callDoc
    @.addChild @.emergency

    @.buttons = [ @.normal, @.callDoc, @.emergency ]
    for button in @.buttons
      button.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     button.setProportionalSize .2, .075

class NormalBtn extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .05, 1, .5
     .setMountPoint 0, .5, .5

    @.domElement.addClass "green"
    @.domElement.setContent @.value.toUpperCase()

class CallDocBtn extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .5, 1, .5
     .setMountPoint .5, .5, .5

    @.domElement.addClass "yellow"
    @.domElement.setContent @.value.toUpperCase()

class EmergencyBtn extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .95, 1, .5
     .setMountPoint 1, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .4, .075

    @.domElement.addClass "red"
    @.domElement.setContent @.value.toUpperCase()

