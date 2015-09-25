class ModulesSequence
  constructor: ( @lesson )->
    console.log "Making a modules sequence"

  start: ()->
    Router.go "modules.show", @.lesson._id

Template.modulesSequence.helpers
  isBinaryChoice: ()->
    console.log "Getting tupe"
    console.log @
    return @.type == "BINARY"

  isMultipleChoice: ()->
    console.log "Getting tupe"
    console.log @
    return @.type == "MULTIPLE_CHOICE"

  isScenario: ()->
    console.log "Getting tupe"
    console.log @
    return @.type == "SCENARIO"

  isSlide: ()->
    console.log "Getting tupe"
    console.log @
    return @.type == "SLIDE"

  isVideo: ()->
    console.log "Getting tupe"
    console.log @
    return @.type == "VIDEO"


