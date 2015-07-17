

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: (@module)->
    super(Template.binaryChoiceModule, @.module)

  handleClick: (event)=>
    console.log "Click Event!"
    if ModuleSurface.buttonDisabled event.target
      return
    else
      ModuleView.handleResponse @, event

  handleInputUpdate: (event)=>
    console.log "Update Event!"

  handleInputEnd: (event)=>
    console.log "End Event!"

