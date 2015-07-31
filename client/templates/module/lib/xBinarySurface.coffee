

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: (@module)->
    super(Template.binaryChoiceModule, @.module)

  handleClick: (event)=>
    if ModuleSurface.buttonDisabled event.target
      return
    else
      ModuleView.handleResponse @, event

