
###
# Scenario Surface
###
class @ScenarioSurface extends ModuleSurface
  constructor: (@module, index)->
    @.size = [800, 600]
    super( @.module , index, @.size)
    
    @.domElement = new DOMElement @, {
      content: "<p>I am scenario choice</p>"
    }

  handleClick: (event)=>
    if event.target.classList.contains "disabled"
      return

    if event.target.classList.contains "response"
      ModuleView.handleResponse @, event

