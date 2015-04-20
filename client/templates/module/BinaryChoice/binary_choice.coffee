
Template.binaryChoiceModule.events
  'click .response': (event, template)->
    response = $(event.target).val()
    moduleSequence = Session.get "modules sequence"
    currentModuleIndex = Session.get "current module index"
    module = moduleSequence[currentModuleIndex]

    hideIncorrectResponses(module)
    
    if isCorrectResponse(event.target)
      $("#sticker_correct").removeClass("hidden")
      Materialize.toast "Correct!", "green rounded"
      playAnswerAudio "correct", module
      handleSuccessfulAttempt(module, 0)
    else
      $("#sticker_incorrect").removeClass("hidden")
      Materialize.toast "<i class='mdi-navigation-close'></i>", "red rounded"
      playAnswerAudio "incorrect", module
      handleFailedAttempt module, [$(event.target).attr "value"], 0

    showNextModuleBtn()

hideIncorrectResponses = ()->
  responseBtns =  $(".response")
  for btn in responseBtns
    if not $(btn).hasClass "correct"
      $(btn).addClass "faded"
    else
      $(btn).addClass "disabled"
      $(btn).addClass "expanded"

