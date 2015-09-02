
class @ModuleSurface extends BaseNode
  constructor: ( @module, @index)->
    super

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5

    @.domElement = new DOMElement @,
      properties:
        "text-align": "center"

    if @.module.audio
      @.audio = new Audio(Scene.get().getContentSrc( @.module.audio ), @.module._id)
    if @.module.correct_audio
      @.correctAudio = new Audio(Scene.get().getContentSrc( @.module.correct_audio ), @.module._id + "correct")
    if @.module.incorrect_audio
      @.incorrectAudio = new Audio(Scene.get().getContentSrc( @.module.incorrect_audio ), @.module._id + "incorrect")

    @.addChild @.audio
    @.addChild @.incorrectAudio
    @.addChild @.correctAudio

    @.positionTransitionable = new Transitionable 1
    @.setPosition()

  setPosition: ()=>
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  onUpdate: ()=>
    @.setPosition()

  moveOffstage: ()=>
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500
    @.hide()
    if @.audio
      @.audio.pause()
    if @.correctAudio
      @.correctAudio.pause()
    if @.incorrectAudio
      @.incorrectAudio.pause()

    @.requestUpdateOnNextTick(@)

  moveOnstage: ()=>
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500
    console.log @
    @.show()
    if @.audio
      @.audio.play()

    @.requestUpdate(@)


