Template.modulesSequence.helpers
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


