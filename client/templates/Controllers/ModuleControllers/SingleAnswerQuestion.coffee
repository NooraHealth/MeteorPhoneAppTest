class @SingleAnswerQuestion extends QuestionBase

  constructor: ( @_module )->
    super @._module

  responseRecieved: ( target )->
    response = $(target).attr "value"

    if response in @._module.correct_answer
      console.log "It's there!"
      if @.audio
        @.audio.pause()

      ModulesController.showResponsePopUp "#correct-pop-up"
      Audio.playAudio "#correct_soundeffect", ()=> @.correctAudio.playWhenReady( ModulesController.shakeNextButton )

      $(target).addClass "expanded"
      console.log @.incorrectResponseButtons()
      for btn in @.incorrectResponseButtons()
        $(btn).addClass "faded"
    else
      ModulesController.showResponsePopUp "#incorrect-pop-up"
      Audio.playAudio "#incorrect_soundeffect", null

  getModuleDiv: ()->
    return $("#" + @._module._id )


