
Template.binaryChoiceModule.events
  'click .response': (event, template)->
    response = $(event.target).val()
    moduleSequence = Session.get "modules sequence"
    currentModuleIndex = Session.get "current module index"
    module = moduleSequence[currentModuleIndex]

    hideIncorrectResponses(module)
    
    if isCorrectResponse(event.target)
      Materialize.toast "<i class='mdi-navigation-check medium'></i>", 5000, "left green rounded"
      playAnswerAudio "correct", module
      handleSuccessfulAttempt(module, 0)
    else
      Materialize.toast "<i class='mdi-navigation-close medium'></i>", 5000, "left red rounded"
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

