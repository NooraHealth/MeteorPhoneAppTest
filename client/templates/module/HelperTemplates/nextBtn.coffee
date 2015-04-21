Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"

    currentModule = modulesSequence[index]
    if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
      correctlyAnswered = Session.get "correctly answered"
      correctlyAnswered.push index
      Session.set "correctly answered", correctlyAnswered
   
    if index < modulesSequence.length
      Session.set "current module index", ++index
      resetTemplate()
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
  if $("[name^=submit_multiple_choice]")
    $("[name^=submit_multiple_choice]").fadeIn()
    
  responseBtns = $(".response")
  for btn in responseBtns
    $(btn).removeClass "disabled"
    $(btn).removeClass "faded"
    $(btn).removeClass "expanded"
    $(btn).removeClass "correctly_selected"
    $(btn).removeClass "incorrectly_selected"
    $(btn).removeClass "selected"


