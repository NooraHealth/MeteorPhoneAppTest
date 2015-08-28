

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: ( @module, index )->
    super @.module, index

    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, 1, 1

    @.image = new ModuleImage(@.module)
    @.noBtn = new NoButton("No")
    @.yesBtn = new YesButton("Yes")
    @.audio = new Audio(Scene.get().getContentSrc() + @.module.audio, @.module._id)
    @.correctAudio = new Audio(Scene.get().getContentSrc() + @.module.correct_audio, @.module._id + "correct")
    @.incorrectAudio = new Audio(Scene.get().getContentSrc() + @.module.incorrect_audio, @.module._id + "incorrect")

    @.addChild @.image
    @.addChild @.audio
    @.addChild @.incorrectAudio
    @.addChild @.correctAudio
    @.addChild @.noBtn
    @.addChild @.yesBtn

    @.buttons = [ @.noBtn, @.yesBtn ]

  onReceive: ( e, payload )->
    button = payload.node
    console.log "in onReceive"
    console.log button
    @.audio.pause()
    if button.value in @.module.correct_answer
      src = @.module.correct_audio
      @.notifyButtons button, "CORRECT", "INCORRECT"
      @.correctAudio.play()
    else
      src = @.module.incorrect_audio
      @.notifyButtons button, "INCORRECT", "CORRECT"
      @.incorrectAudio.play()

  notifyButtons: (button, response, otherResponse)=>
    for btn in @.buttons
      console.log btn
      console.log button
      if btn == button
        btn.respond response
      else
        btn.respond otherResponse

  moveOffstage: ()->
    super
    console.log "About to try to pause the audio"
    @.audio.pause()
    @.correctAudio.pause()
    @.incorrectAudio.pause()

  moveOnstage: ()->
    super
    console.log "About to try to play the audio"
    @.audio.play()

class ModuleImage extends Node
  constructor: (@module)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .4, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .8

    img = Scene.get().getContentSrc() + @.module.image
    @.domElement = new DOMElement @, {
      content: "<img src='#{img}' class='binary-image'></img>"
    }

class YesButton extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .05, 1, .5
     .setMountPoint 0, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .4, .2

    @.domElement = new DOMElement @, {
      content: "<a class='full-width btn green waves-light waves-effect white-text'>YES</a>"
    }

class NoButton extends ResponseButton
  constructor: (@value)->
    super @.value

    @.setOrigin .5, .5, .5
     .setAlign .95, 1, .5
     .setMountPoint 1, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .4, .2

    @.domElement = new DOMElement @, {
      content: "<a class='full-width btn red waves-light waves-effect white-text'>NO</a>"
    }


