Template.moduleLayout.helpers
  contentBlurred: ()->
    return Session.get "module content blurred"

  module: ()->
    #id = Session.get "current module id"
    id = FlowRouter.getParam("_id")
    console.log "Id", id
    module =  Modules.findOne { _id: id }
    console.log module
    return module

Template.moduleLayout.onRendered ()->
  console.log "I am a layout being rendered!"

