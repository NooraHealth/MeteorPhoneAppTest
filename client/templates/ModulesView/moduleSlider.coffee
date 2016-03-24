Template.moduleSlider.helpers
  modules: ()->
    _id = FlowRouter.getParam "_id"
    lesson = Lessons.findOne { _id: _id }
    return lesson.getModulesSequence()

  getTemplate: ( context )->
    console.log "Getting the module slider contecxt"
    console.log Template.currentData()
    module = Template.currentData()
    if module.type == "BINARY"
      template = "binaryChoiceModule"
    if module.type == "MULTIPLE_CHOICE"
      template = "multipleChoiceModule"
    if module.type == "SCENARIO"
      template = "scenarioModule"
    if module.type == "VIDEO"
      template = "videoModule"
    if module.type == "SLIDE"
      template = "slideModule"

    return template
