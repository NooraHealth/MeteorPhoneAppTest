class @QuestionBase
  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio"
    @.correctAudio = new Audio @._module.correctAnswerAudio(), "#correctaudio"
    @.incorrectAudio = new Audio @._module.incorrectAnswerAudio(), "#incorrectaudio"
    console.log "Built audio for Question Base"
    console.log @.audio
    console.log @.correctAudio
    console.log @.incorrectAudio

  begin: ()->
    console.log "Begging the QUESTION"
    console.log @.audio
    @.audio.playWhenReady()

  end: ()->
    @.audio.pause()
    @.correctAudio.pause()
    @.incorrectAudio.pause()

