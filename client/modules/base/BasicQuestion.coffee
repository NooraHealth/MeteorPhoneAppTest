class @BasicQuestion

  onReceive: ( e, payload )->
    button = payload.node
    if @.audio
      @.audio.pause()
    if button.value in @._module.correct_answer
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

  resetContent: ()->
    if @.title
      @.title.setTitle @._module.question
    if @.image
      console.log "Setting the image content"
      @.image.setSrc @._module.image
    for button in @.buttons
      button.reset()


