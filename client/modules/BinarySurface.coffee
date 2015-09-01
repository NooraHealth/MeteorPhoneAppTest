

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: ( @module, index )->
    super @.module, index
    @.extend BasicQuestion.prototype
    BasicQuestion.apply @

    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, 1, 1

    @.domElement.addClass "card"

    @.image = new ModuleImage(@.module)
    @.noBtn = new NoButton("No")
    @.yesBtn = new YesButton("Yes")

    @.addChild @.image
    @.addChild @.noBtn
    @.addChild @.yesBtn

    @.buttons = [ @.noBtn, @.yesBtn ]
    for button in @.buttons
      button.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     button.setProportionalSize .4, .075

class NoButton extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .05, 1, .5
     .setMountPoint 0, .5, .5

    @.domElement.addClass "green"
    @.domElement.setContent @.value.toUpperCase()

class YesButton extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .95, 1, .5
     .setMountPoint 1, .5, .5

    @.domElement.addClass "red"
    @.domElement.setContent @.value.toUpperCase()

