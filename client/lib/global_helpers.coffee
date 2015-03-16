Template.registerHelper 'isLastModule', () ->
    index = Session.get "current module index"
    sequence = Session.get "module sequence"
    if !sequence?
      return false
    return index == sequence.length - 1

Template.registerHelper 'pathToCurrentChapterPage', ()->
    chapter = Session.get "current chapter"
    if !chapter?
      return '/'
    else
      return '/chapter/' + chapter

Template.registerHelper 'isFirstModule', ()->
    return Session.equals "current module index", 0


