Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    
    if index < modulesSequence.length
      Session.set "current module index", ++index
    else
      currentChapter = Session.get "current chapter index"
      Session.set "current chapter index", currentChapter + 1
      Router.go "home"

Template.nextBtn.helpers
  isHidden: ()->
    return Session.get "next button is hidden"

  
