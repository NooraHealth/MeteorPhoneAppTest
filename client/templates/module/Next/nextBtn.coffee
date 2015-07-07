Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    incorrectlyAnswered = Session.get "incorrectly answered"
    correctlyAnswered = Session.get "correctly answered"
    currentModule = modulesSequence[index]
    
    module = undefined
    console.log "1"
    #if correctlyAnswered.length == modulesSequence.length
    if allModulesComplete()
      console.log "2"
      console.log "All modules complte"
      Meteor.user().updateLessonsComplete(currLesson)
      Router.go "home"
      return

    if !isAQuestion(currentModule)
      console.log "3"
      correctlyAnswered.push index
      Session.set "correctly answered", correctlyAnswered
   
    if isLastModuleInSeries()
      console.log "3"
      moduleIndex = 0
      if hasAttemptedAllModules()
        console.log "4"
        moduleIndex = incorrectlyAnswered[0]
      else
        console.log "5"
        moduleIndex = ++index
      Session.set "current module index", moduleIndex
      resetTemplate()
      console.log "6"
      playAudio 'question', Session.get("modules sequence")[moduleIndex]

    else if !hasAllCorrectAnswers()
      console.log "7"
      moduleIndex = incorrectlyAnswered[0]
      Session.set "current module index", moduleIndex
      resetTemplate()
      playAudio 'question', Session.get("modules sequence")[moduleIndex]
    else
      console.log "8"
      Meteor.user().updateLessonsComplete(currLesson)
      Router.go "home"

    Session.set "success toast is visible", false
    Session.set "fail toast is visible", false
    Session.set "next button is hidden", nextBtnShouldHide()

Template.nextBtn.helpers
  phone: ()->
    return Meteor.Device.isPhone()

Template.phoneNextBtn.helpers
  id: ()->
    return nextBtnId()

  isHidden: ()->
    return isHidden()

Template.browserNextBtn.helpers

  allModulesComplete: ()->
    return allModulesComplete()

  isHidden: ()->
    return isHidden()

  id: ()->
    console.log "Getting the next btn id"
    return nextBtnId()

isHidden = ()->
  return Session.get "next button is hidden"
  
nextBtnId = ()->
  return "nextbtn"

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
