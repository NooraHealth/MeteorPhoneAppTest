Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
   
    if index < modulesSequence.length
      resetTemplate()
      Session.set "current module index", ++index
    else
      currentChapter = Session.get "current chapter index"
      Session.set "current chapter index", currentChapter + 1
      Router.go "home"

Template.nextBtn.helpers
  isLastModule: ()->
    numModules = (Session.get "modules sequence").length
    return Session.get "current module index" == numModules-1

  isHidden: ()->
    return Session.get "next button is hidden"

resetTemplate = ()->
  responseBtns = $(".response")
  for btn in responseBtns
    $(btn).removeClass "disabled"
    $(btn).removeClass "faded"
    $(btn).removeClass "expanded"

