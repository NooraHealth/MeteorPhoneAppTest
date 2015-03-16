Template.registerHelper {
  isLastModule: () ->
    console.log "is this the laste module?"
    index = Session.get "current module index"
    sequence = Session.get "module sequence"
    console.log index
    console.log sequence
    if !sequence?
      return false
    return index == sequence.length - 1
}


