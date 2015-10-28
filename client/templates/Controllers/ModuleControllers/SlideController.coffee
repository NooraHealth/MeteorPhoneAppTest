
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.src, "#audio"

  begin: ()->
    @.audio.playWhenReady()

  end: ()->
    @.audio.pause()
