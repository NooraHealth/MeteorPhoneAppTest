
class @ModuleSurface extends BaseNode
  constructor: ( @_module )->
    super

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5

    @.domElement = new DOMElement @,
      properties:
        "text-align": "center"

    @.domElement.setContent ""

    #add the audio to the footer for better playability
    footer = Scene.get().getFooter()
    if @._module.audio
      @.audio = new Audio(Scene.get().getContentSrc( @._module.audio ), @._module._id)
    if @._module.correct_audio
      @.correctAudio = new Audio(Scene.get().getContentSrc( @._module.correct_audio ), @._module._id + "correct")
    if @._module.incorrect_audio
      @.incorrectAudio = new Audio(Scene.get().getContentSrc( @._module.incorrect_audio ), @._module._id + "incorrect")

    footer.addChild @.audio
    footer.addChild @.incorrectAudio
    footer.addChild @.correctAudio

    @.positionTransitionable = new Transitionable 1

  resetAudio: ()=>
    if @.audio
      @.audio.setSrc @._module.audio
    if @.incorrectAudio
      @.audio.setSrc @._module.incorrect_audio
    if @.correctAudio
      @.audio.setSrc @._module.correct_audio

  setModule: ( module )->
    @._module = module
    @.resetAudio()

  onUpdate: ()=>
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  moveOffstage: ()=>
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500
    if @.audio
      @.audio.hide()
      @.audio.pause()
    if @.correctAudio
      @.correctAudio.hide()
      @.correctAudio.pause()
    if @.incorrectAudio
      @.incorrectAudio.hide()
      @.incorrectAudio.pause()

    @.requestUpdate(@)

  moveOnstage: ()=>
    console.log "MOVING ONSTAGE"
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500
    if @.audio
      @.audio.play()
    if @.correctAudio
      @.correctAudio.show()
    if @.incorrectAudio
      @.incorrectAudio.show()

    @.requestUpdate(@)


