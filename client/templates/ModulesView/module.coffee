Template.module.helpers
  contentBlurred: ()->
    return Session.get "module content blurred"

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

