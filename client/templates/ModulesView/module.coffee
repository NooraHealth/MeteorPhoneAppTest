Template.module.helpers
  contentBlurred: ()->
    return Session.get "module content blurred"

  module: ()->
    #id = Session.get "current module id"
    id = FlowRouter.getParam("_id")
    console.log "Id", id
    module =  Modules.findOne { _id: id }
    console.log module
    return module

  isCordova: ()->
    return Meteor.isCordova

  isBinaryChoice: ()->
    return @.type == "BINARY"

  isMultipleChoice: ()->
    return @.type == "MULTIPLE_CHOICE"

  isScenario: ()->
    return @.type == "SCENARIO"

  isSlide: ()->
    return @.type == "SLIDE"

  isVideo: ()->
    return @.type == "VIDEO"

