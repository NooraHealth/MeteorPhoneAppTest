Template.nextBtn.events
  "click #nextbtn": ()->
    Session.set "next button is hidden", true
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    incorrectlyAnswered = Session.get "incorrectly answered"
    correctlyAnswered = Session.get "correctly answered"
    currentModule = modulesSequence[index]
    if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
      correctlyAnswered.push index
      Session.set "correctly answered", correctlyAnswered
   
    if index+1 < modulesSequence.length
      if correctlyAnswered.length + incorrectlyAnswered.length == modulesSequence.length
        Session.set "current module index", incorrectlyAnswered[0]
      else
        Session.set "current module index", ++index
      resetTemplate()

    else if incorrectlyAnswered.length > 0
      Session.set "current module index", incorrectlyAnswered[0]
      resetTemplate()
    else
      currentChapter = Session.get "current chapter index"
      Session.set "current chapter index", currentChapter + 1
      stopAllAudio()
      Router.go "home"

Template.nextBtn.helpers
  isLastModule: ()->
    numModules = (Session.get "modules sequence").length
    numIncorrect = (Session.get "incorrectly answered").length

    console.log "is this the last module? ", numModules
    console.log "current module index", Session.get "current module index"
    index = Session.get "current module index"
    return index == numModules-1 and numIncorrect == 0

  isHidden: ()->
    return Session.get "next button is hidden"

resetTemplate = ()->
  stopAllAudio()

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

stopAllAudio = ()->
  for audioElem in $("audio")
    audioElem.pause()
