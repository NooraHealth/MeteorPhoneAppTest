Template.nextBtn.events
  "click #nextbtn": ()->
    console.log "NEXT BUTTON"
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    incorrectlyAnswered = Session.get "incorrectly answered"
    correctlyAnswered = Session.get "correctly answered"
    currentModule = modulesSequence[index]
    
    module = undefined

    #if correctlyAnswered.length == modulesSequence.length
    if allModulesComplete()
      Meteor.user().updateLessonsComplete(currLesson)
      Router.go "home"
      return

    if !isAQuestion(currentModule)
      correctlyAnswered.push index
      Session.set "correctly answered", correctlyAnswered
   
    if isLastModuleInSeries()
      moduleIndex = 0
      if hasAttemptedAllModules()
        moduleIndex = incorrectlyAnswered[0]
      else
        moduleIndex = ++index
      Session.set "current module index", moduleIndex
      resetTemplate()
      playAudio 'question', Session.get("modules sequence")[moduleIndex]

    else if !hasAllCorrectAnswers()
      moduleIndex = incorrectlyAnswered[0]
      Session.set "current module index", moduleIndex
      resetTemplate()
      playAudio 'question', Session.get("modules sequence")[moduleIndex]
    else
      Meteor.user().updateLessonsComplete(currLesson)
      Router.go "home"

    Session.set "next button is hidden", nextBtnShouldHide()

Template.nextBtn.helpers
  allModulesComplete: ()->
    return allModulesComplete()

  isHidden: ()->
    return Session.get "next button is hidden"

hasAllCorrectAnswers = ()->
  incorrectlyAnswered = Session.get "incorrectly answered"
  correctlyAnswered = Session.get "correctly answered"
  modulesSequence = Session.get "modules sequence"
  return incorrectlyAnswered.length <= 0 and (correctlyAnswered.length == modulesSequence.length)

isLastModuleInSeries = ()->
  index = Session.get "current module index"
  modulesSequence = Session.get "modules sequence"
  return index+1 < modulesSequence.length

hasAttemptedAllModules = ()->
  modulesSequence = Session.get "modules sequence"
  incorrectlyAnswered = Session.get "incorrectly answered"
  correctlyAnswered = Session.get "correctly answered"
  return correctlyAnswered.length + incorrectlyAnswered.length == modulesSequence.length

resetTemplate = ()->
  stopAllAudio()

  responseBtns = $(".response")
  for btn in responseBtns
    $(btn).removeClass "disabled"
    $(btn).removeClass "faded"
    $(btn).removeClass "expanded"
    $(btn).removeClass "correctly_selected"
    $(btn).removeClass "incorrectly_selected"
    $(btn).removeClass "selected"

