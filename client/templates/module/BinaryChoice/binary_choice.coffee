
Template.binaryChoiceModule.reg
  'click .response': (event, template)->
    if buttonDisabled event.target
      return
    else
      response = $(event.target).val()
      handleResponse response
    event.stopPropagation()

Template.binaryChoiceModule.events
  'click .response': (event, template)->
    if buttonDisabled event.target
      return
    else
      response = $(event.target).val()
      handleResponse response
    event.stopPropagation()

class @BinarySurface extends ModuleSurface
  constructor: (@module)->
    super(Template.binaryChoiceModule, @.module)
    console.log "This is after building my surface"
    console.log @
  
