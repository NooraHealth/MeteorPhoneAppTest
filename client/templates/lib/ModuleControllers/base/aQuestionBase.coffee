class @QuestionBase
  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio"
    @.correctAudio = new Audio @._module.correctAnswerAudio(), "#correctaudio"
    @.incorrectAudio = new Audio @._module.incorrectAnswerAudio(), "#incorrectaudio"

  begin: ()->
    console.log @.audio
    @.audio.playWhenReady()

  end: ()->
    @.audio.pause()
    @.correctAudio.pause()
    @.incorrectAudio.pause()

