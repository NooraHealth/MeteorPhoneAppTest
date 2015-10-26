
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.src, "#audio"

  moveOnstage: ()->
    @.audio.playWhenReady()

  moveOffstage: ()->
    @.audio.pause()
