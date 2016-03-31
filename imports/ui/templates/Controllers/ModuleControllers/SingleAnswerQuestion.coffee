class @SingleAnswerQuestion extends QuestionBase

  constructor: ( @_module )->
    super @._module

  responseRecieved: ( target )->
    @._completedQuestion = true
    response = $(target).attr "value"

    if response in @._module.correct_answer
      @._completedQuestion = true
      if @.audio
        @.audio.pause()
      if @.intro
        @.intro.pause()
      
      swal {
        title: ""
        type: "success"
        timer: 3000
      }

      @.correctSoundEffect.playAudio ()=> @.correctAudio.playWhenReady( ModulesController.readyForNextModule )

      $(target).addClass "expanded correctly-selected"
      console.log @.incorrectResponseButtons()
      for btn in @.incorrectResponseButtons()
        if not $(btn).hasClass "faded"
          $(btn).addClass "faded"
    else
      swal {
        title: ""
        type: "error"
        timer: 2000
      }

      @.incorrectSoundEffect.playAudio null
      $(target).addClass "faded"
      $(target).addClass "incorrectly-selected"

  getModuleDiv: ()->
    return $("#" + @._module._id )


