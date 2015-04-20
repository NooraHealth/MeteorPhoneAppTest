
Template.binaryChoiceModule.events
  'click .response': (event, template)->
    response = $(event.target).val()
    moduleSequence = Session.get "modules sequence"
    currentModuleIndex = Session.get "current module index"
    module = moduleSequence[currentModuleIndex]

    hideIncorrectResponses(module)
    
    if isCorrectResponse(event.target)
      console.log "Correct"
      #showSticker "correct", module
      playAnswerAudio "correct", module
      handleSuccessfulAttempt(module, 0)
    else
      console.log "incorrect"
      #showSticker "incorrect", module
      playAnswerAudio "incorrect", module
      handleFailedAttempt module, [$(event.target).attr "value"], 0

    showNextModuleBtn(module)

hideIncorrectResponses = (module)->
  console.log "hiding the incorrent response"
  responseBtns =  $(".response")
  for btn in responseBtns
    if not $(btn).hasClass "correct"
      $(btn).hide()
    else
      $(btn).addClass "disabled"
      $(btn).removeClass "response"
      console.log "making this button disabled: ", btn

