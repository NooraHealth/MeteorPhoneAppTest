class @QuestionBase
  constructor: ( @_module )->
    @.audio = new Audio @._module.audio, "#audio"
    @.correctAudio = new Audio @._module.correct_audio, "#correctaudio"
    @.incorrectAudio = new Audio @._module.incorrect_audio, "#incorrectaudio"
    console.log "Built audio for Question Base"
    console.log @.audio
    console.log @.correctAudio
    console.log @.incorrectAudio

  moveOnstage: ()->
    @.audio.playWhenReady()

  moveOffstage: ()->
    @.audio.pause()
    @.correctAudio.pause()
    @.incorrectAudio.pause()

