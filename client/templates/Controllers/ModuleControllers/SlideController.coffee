
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio", @._module._id

  replay: ()->
    @.audio.pause()
    @.audio.playWhenReady( ModulesController.shakeNextButton )

  stopAllAudio: ()->
    @.audio.pause()

  begin: ()=>
    @.audio.playWhenReady ModulesController.shakeNextButton

  end: ()->
    @.audio.pause()
    ModulesController.stopShakingNextButton()
