
Template.binaryChoiceModule.events
  'click .response': (event, template)->
    response = $(event.target).val()
    handleResponse response
