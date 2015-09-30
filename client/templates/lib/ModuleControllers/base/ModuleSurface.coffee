
class @ModuleSurface
  constructor: ( @_module )->

  addAudio: ( parent )=>

  removeAudio: ( parent )=>

  resetAudio: ()=>

  setModule: ( module )->
    @._module = module

  moveOffstage: ()=>

  moveOnstage: ()=>
    if @.audio
      @.audio.play()
    if @.correctAudio
      @.correctAudio.show()
    if @.incorrectAudio
      @.incorrectAudio.show()

