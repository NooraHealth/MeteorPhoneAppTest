

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: (@module)->
    super(Template.binaryChoiceModule, @.module)
    @.registerFamousEvents()

  handleClick: (event)=>
    console.log "Click Event!"
    if buttonDisabled event.target
      return
    else
      ModuleView.handleResponse @, event

  handleInputUpdate: (event)=>
    console.log "Update Event!"

  handleInputEnd: (event)=>
    console.log "End Event!"

