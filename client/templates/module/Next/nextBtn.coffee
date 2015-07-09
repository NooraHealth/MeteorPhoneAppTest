Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    incorrectlyAnswered = Session.get "incorrectly answered"
    correctlyAnswered = Session.get "correctly answered"
    currentModule = modulesSequence[index]
    
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

    else if !hasAllCorrectAnswers()
      moduleIndex = incorrectlyAnswered[0]
    else
      Meteor.user().updateLessonsComplete(currLesson)
      Router.go "home"
      return

    resetTemplate()
    id = modulesSequence[moduleIndex]._id
    playAudio 'question', id

    Session.set "current module index", moduleIndex
    Session.set "success toast is visible", false
    Session.set "fail toast is visible", false
    Session.set "next button is hidden", nextBtnShouldHide()


    fview = FView.byId "footer"
    surface = fview.view or fview.surface
    eventOutput = surface._eventOutput
    eventOutput.emit 'showModule', id

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

Template.nextBtn.onRendered ()->
  #get the lightbox and subscribe it to the next btn events
  lightbox = FView.byId "lightbox"
  console.log lightbox
  fview = FView.from(this)
  surface = fview.view or fview.surface
  nextBtnEventHandler = surface._eventOutput
  console.log surface


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
