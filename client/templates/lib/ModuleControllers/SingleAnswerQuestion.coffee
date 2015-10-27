class @SingleAnswerQuestion extends QuestionBase

  constructor: ( @_module )->
    super @._module

  responseRecieved: ( target )->
    response = $(target).attr "value"

    console.log response
    console.log @._module.correct_answer
    console.log response in @._module.correct_answer
    if response in @._module.correct_answer
      console.log "It's there!"
      if @.audio
        @.audio.pause()

      ding = $("#correct_soundeffect")[0]
      ding.play()
      ding.addEventListener "ended", ()=>
        @.correctAudio.playWhenReady()

      $(target).addClass "move-up-and-expand"
      for btn in @.incorrectResponseButtons
        $(btn).addClass "fade-out"
    else
      $("#incorrect_soundeffect")[0].play()

  getModuleDiv: ()->
    return $("#" + @._module._id )


