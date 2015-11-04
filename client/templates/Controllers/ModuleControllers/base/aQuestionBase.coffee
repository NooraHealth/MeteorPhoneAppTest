class @QuestionBase
  constructor: ( @_module )->
    @.audio = new Audio @._module.audioSrc(), "#audio"
    @.correctAudio = new Audio @._module.correctAnswerAudio(), "#correctaudio"
    #@.incorrectAudio = new Audio @._module.incorrectAnswerAudio(), "#incorrectaudio"

  correctResponseButtons: ()->
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> @.isCorrectAnswer $(elem).attr "value"

  incorrectResponseButtons: ()->
    #return $("#" + @._module._id).find(".response").filter ( elem )=> $(elem).val() not in @._module.correct_answer
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> not @.isCorrectAnswer $(elem).attr "value"

  isCorrectAnswer: ( val )=>
    return val in @._module.correct_answer

  begin: ()->
    @.audio.playWhenReady()

  end: ()->
    @.audio.pause()
    @.correctAudio.pause()
    #@.incorrectAudio.pause()
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

