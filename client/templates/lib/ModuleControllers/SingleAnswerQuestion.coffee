class @SingleAnswerQuestion extends QuestionBase

  constructor: ( @_module )->
    super @._module

  recieveResponse: ( buttonElement )->
    if @.audio
      @.audio.pause()
    if buttonElement.val() in @._module.correct_answer
      if @.correctAudio
        @.correctAudio.play()
    else
      if @.incorrectAudio
        @.incorrectAudio.play()

    getCorrectAnswerButton().addClass "move-up-and-expand"

    getIncorrectAnswerButtons().each ( btn )->
      $(btn).addClass "fade-out"

  getCorrectAnswerButton: ()->
    return @.getModuleDiv().find(".correct")[0]

  getIncorrectAnswerButtons: ()->
    return @.getModuleDiv().find ".incorrect"

  getModuleDiv: ()->
    return $("#" + @._module._id )


