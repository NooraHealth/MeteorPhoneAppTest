
Template.binaryChoiceModule.events
  'click .response': (event, template)->
    if buttonDisabled event.target
      return
    else
      response = $(event.target).val()
      handleResponse response
    event.stopPropagation()

  
