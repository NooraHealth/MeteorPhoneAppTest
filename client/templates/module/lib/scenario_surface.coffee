
###
# Scenario Surface
###
class @ScenarioSurface extends ModuleSurface
  constructor: (@module)->
    @.size = [1000, undefined]
    super(Template.scenarioModule, @.module)

  handleClick: (event)=>
    if event.target.classList.contains "disabled"
      return

    if event.target.classList.contains "response"
      ModuleView.handleResponse @, event

