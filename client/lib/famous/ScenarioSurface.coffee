
###
# Scenario Surface
###
class @ScenarioSurface extends ModuleSurface
  constructor: (@module)->
    @.size = [800, 600]
    super( @.module )

  handleClick: (event)=>
    if event.target.classList.contains "disabled"
      return

    if event.target.classList.contains "response"
      ModuleView.handleResponse @, event

