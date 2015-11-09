class @SingleAnswerQuestion extends QuestionBase

  constructor: ( @_module )->
    super @._module

  responseRecieved: ( target )->
    response = $(target).attr "value"

    if response in @._module.correct_answer
      console.log "It's there!"
      if @.audio
        @.audio.pause()

      
      swal {
        title: ""
        type: "success"
        timer: 3000
      }

      Audio.playAudio "#correct_soundeffect", ()=> @.correctAudio.playWhenReady( ModulesController.shakeNextButton )

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

      Audio.playAudio "#incorrect_soundeffect", null
      $(target).addClass "faded"
      $(target).addClass "incorrectly-selected"


  getModuleDiv: ()->
    return $("#" + @._module._id )


