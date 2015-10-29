
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.src, "#audio"

  begin: ()=>
    console.log "Beginning the slide!"
    @.audio.playWhenReady ModulesController.shakeNextButton

  end: ()->
    @.audio.pause()
    ModulesController.stopShakingNextButton()
