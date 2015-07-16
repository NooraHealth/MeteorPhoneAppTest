Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    modulesSequence = Session.get "modules sequence"
    currentModule = modulesSequence[index]
    
    #if correctlyAnswered.length == modulesSequence.length
    if allModulesComplete()
      endSequence()
      return

    if !isAQuestion(currentModule)
      recordModuleAsCorrectlyAnswered()
   
    if isLastModuleInSeries()
      nextModule = 0
      if hasAttemptedAllModules()
        nextModule = nextIncorrectModule()
      else
        nextModule = ++index

    else if !hasAllCorrectAnswers()
      nextModule = nextIncorrectModule()
    else
      endSequence()
      return

    ModuleView.stopAllAudio()
    console.log "next module index"
    console.log nextModule

    Session.set "current module index", nextModule
    Session.set "success toast is visible", false
    Session.set "fail toast is visible", false
    Session.set "next button is hidden", nextBtnShouldHide()

    emitShowModuleEvent(nextModule)

emitShowModuleEvent= (module)->
  fview = FView.byId "footer"
  surface = fview.view or fview.surface
  eventOutput = surface._eventOutput
  eventOutput.emit 'showModule', module

recordModuleAsCorrectlyAnswered = ()->
  index = Session.get "current module index"
  correctlyAnswered = Session.get "correctly answered"
  correctlyAnswered.push index
  Session.set "correctly answered", correctlyAnswered

nextIncorrectModule = ()->
  incorrectlyAnswered = Session.get "incorrectly answered"
  return incorrectlyAnswered[0]

endSequence = ()->
  currLesson = Session.get "current lesson"
  Meteor.user().updateLessonsComplete(currLesson)
  ModuleView.stopAllAudio()
  Router.go "home"


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

