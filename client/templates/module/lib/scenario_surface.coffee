
###
# Scenario Surface
###
class @ScenarioSurface extends ModuleSurface
  constructor: (@module)->
    super(Template.scenarioModule, @.module)
