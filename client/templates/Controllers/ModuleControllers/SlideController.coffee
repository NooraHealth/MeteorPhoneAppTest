
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio"

  begin: ()=>
    @.audio.playWhenReady ModulesController.shakeNextButton

  end: ()->
    @.audio.pause()
    ModulesController.stopShakingNextButton()
