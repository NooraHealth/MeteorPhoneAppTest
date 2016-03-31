
###
# Slide Surface
###
class @SlideController

  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio", @._module._id

  replay: ()->
    @.audio.pause()
    @.audio.playWhenReady( ModulesController.readyForNextModule )

  stopAllAudio: ()->
    @.audio.pause()

  begin: ()=>
    @.audio.playWhenReady ModulesController.readyForNextModule

  end: ()->
    @.audio.pause()
