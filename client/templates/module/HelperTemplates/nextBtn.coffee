Template.nextBtn.events
  "click #nextbtn": ()->
    Session.set "next button is hidden", true
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    incorrectlyAnswered = Session.get "incorrectly answered"
    correctlyAnswered = Session.get "correctly answered"
    currentModule = modulesSequence[index]
    
    module = undefined
    console.log "Here are the inccorectlyAnswered: ", incorrectlyAnswered
    console.log "Here are the correctly answered", correctlyAnswered
    console.log "Here is the current module", currentModule
    console.log "module index: ", index
    if correctlyAnswered.length == modulesSequence.length
      chapterComplete()
      return

    if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
      correctlyAnswered.push index
      Session.set "correctly answered", correctlyAnswered
   
    if index+1 < modulesSequence.length
      console.log "Less than modules sequence.length"
      moduleIndex = 0
      if correctlyAnswered.length + incorrectlyAnswered.length == modulesSequence.length
        moduleIndex = incorrectlyAnswered[0]
      else
        moduleIndex = ++index
      Session.set "current module index", moduleIndex
      resetTemplate()
      playAudio 'question', Session.get("modules sequence")[moduleIndex]

    else if incorrectlyAnswered.length > 0
      moduleIndex = incorrectlyAnswered[0]
      Session.set "current module index", moduleIndex
      resetTemplate()
      playAudio 'question', Session.get("modules sequence")[moduleIndex]
    else
      chapterComplete()

Template.nextBtn.helpers
  isLastModule: ()->
    return isLastModule()

  isHidden: ()->
    return Session.get "next button is hidden"

resetTemplate = ()->
  stopAllAudio()

  responseBtns = $(".response")
  console.log "Here are the response btns to reset: ", responseBtns
  for btn in responseBtns
    $(btn).removeClass "disabled"
    $(btn).removeClass "faded"
    $(btn).removeClass "expanded"
    $(btn).removeClass "correctly_selected"
    $(btn).removeClass "incorrectly_selected"
    $(btn).removeClass "selected"


chapterComplete = () ->
  currentChapter = Session.get "current chapter index"
  Session.set "current chapter index", currentChapter + 1
  stopAllAudio()
  Router.go "home"
