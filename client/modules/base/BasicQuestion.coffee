class @BasicQuestion

  onReceive: ( e, payload )->
    button = payload.node
    if @.audio
      @.audio.pause()
    if button.value in @.module.correct_answer
      @.notifyButtons button, "CORRECT", "INCORRECT"
      if @.correctAudio
        @.correctAudio.play()
    else
      @.notifyButtons button, "INCORRECT", "CORRECT"
      if @.incorrectAudio
        @.incorrectAudio.play()

  notifyButtons: (button, response, otherResponse)=>
    for btn in @.buttons
      if btn == button
        btn.respond response
      else
        btn.respond otherResponse
      btn.disable()

