class @QuestionBase
  constructor: ( @_module )->
    @._completedQuestion = false
    @.audio = new Audio @._module.audioSrc(), "#audio"
    @.correctAudio = new Audio @._module.correctAnswerAudio(), "#correctaudio"

  replay: ()->
    @.stopAllAudio()
    if @._completedQuestion
      @.correctAudio.playWhenReady()
    else
      @.audio.playWhenReady()

  correctResponseButtons: ()->
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> @.isCorrectAnswer $(elem).attr "value"

  incorrectResponseButtons: ()->
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> not @.isCorrectAnswer $(elem).attr "value"

  isCorrectAnswer: ( val )=>
    return val in @._module.correct_answer

  stopAllAudio: ()->
    @.audio.pause()
    @.correctAudio.pause()

  begin: ()->
    @.audio.playWhenReady()

  end: ()->
    @.stopAllAudio()

    @.resetState()
    ModulesController.stopShakingNextButton()
  
  resetState: ()->
    for btn in @.incorrectResponseButtons()
      if $(btn).hasClass "incorrectly-selected"
        $(btn).removeClass "incorrectly-selected"
      if $(btn).hasClass "faded"
        $(btn).removeClass "faded"
    for btn in @.correctResponseButtons()
      if $(btn).hasClass "correctly-selected"
        $(btn).removeClass "correctly-selected"
      if $(btn).hasClass "expanded"
        $(btn).removeClass "expanded"

