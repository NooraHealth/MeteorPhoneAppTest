
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio"

  replay: ()->
    @.audio.pause()
    @.audio.playWhenReady( ModulesController.shakeNextButton )

  begin: ()=>
    @.audio.playWhenReady ModulesController.shakeNextButton

  end: ()->
    @.audio.pause()
    ModulesController.stopShakingNextButton()
