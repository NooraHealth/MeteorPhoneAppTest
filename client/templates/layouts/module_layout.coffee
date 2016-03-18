Template.moduleLayout.helpers

  moduleId: ()->
    return FlowRouter.getParam("_id")

  module: ()->
    id = FlowRouter.getParam("_id")
    module =  Modules.findOne { _id: id }
    return module

