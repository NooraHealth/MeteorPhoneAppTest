Template.modulesSequence.helpers
  contentBlurred: ()->
    return Session.get "module content blurred"

  module: ()->
    id = Session.get "current module id"
    return Modules.findOne { _id: id }

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

Template.modulesSequence.onRendered ()->
  Scene.get().startModulesSequence()
