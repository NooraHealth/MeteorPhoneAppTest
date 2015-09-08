
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
    @.addAudio footer
    @.audioParent = footer

    @.positionTransitionable = new Transitionable 1

  addAudio: ( parent )=>
    if @._module.audio
      @.audio = new Audio(Scene.get().getContentSrc( @._module.audio ), @._module._id)
    if @._module.correct_audio
      @.correctAudio = new Audio(Scene.get().getContentSrc( @._module.correct_audio ), @._module._id + "correct")
    if @._module.incorrect_audio
      @.incorrectAudio = new Audio(Scene.get().getContentSrc( @._module.incorrect_audio ), @._module._id + "incorrect")

    parent.addChild @.audio
    parent.addChild @.incorrectAudio
    parent.addChild @.correctAudio

  removeAudio: ( parent )=>
    if @.audio
      parent.removeChild @.audio
    if @.incorrectAudio
      parent.removeChild @.incorrectAudio
    if @.correctAudio
      parent.removeChild @.correctAudio

  resetAudio: ()=>
    @.removeAudio @.audioParent
    @.addAudio @.audioParent
    #if @.audio
      #@.audio.setSrc Scene.get().getContentSrc @._module.audio , @._module._id
    #if @.incorrectAudio
      #@.audio.setSrc Scene.get().getContentSrc @._module.incorrect_audio , @._module._id
    #if @.correctAudio
      #@.audio.setSrc Scene.get().getContentSrc @._module.correct_audio , @._module._id

  setModule: ( module )->
    console.log "Setting the module in the module surface"
    @._module = module
    @.resetAudio()

  onUpdate: ()=>
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  moveOffstage: ()=>
    console.log "MOVING OFF STAGE"
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
    console.log "ABOUT TO PLAY AUDIO"
    if @.audio
      @.audio.play()
    if @.correctAudio
      @.correctAudio.show()
    if @.incorrectAudio
      @.incorrectAudio.show()

    @.requestUpdate(@)


