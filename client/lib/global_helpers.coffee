Template.registerHelper 'isLastModule', () ->
    console.log "is this the laste module?"
    index = Session.get "current module index"
    sequence = Session.get "module sequence"
    console.log index
    console.log sequence
    if !sequence?
      return false
    return index == sequence.length - 1

Template.registerHelper 'isFirstModule', ()->
    console.log "Getting if this is the first module"
    return Session.equals "current module index", 0


