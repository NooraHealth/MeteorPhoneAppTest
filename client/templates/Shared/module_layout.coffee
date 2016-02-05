Template.moduleLayout.helpers

  module: ()->
    #id = Session.get "current module id"
    id = FlowRouter.getParam("_id")
    console.log "Id", id
    module =  Modules.findOne { _id: id }
    console.log module
    return module

