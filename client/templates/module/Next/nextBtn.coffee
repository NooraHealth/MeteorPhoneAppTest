Template.nextBtn.events
  "click #nextbtn": ()->
    index = Session.get "current module index"
    currLesson = Session.get "current lesson"
    modulesSequence = Session.get "modules sequence"
    incorrectlyAnswered = Session.get "incorrectly answered"
    correctlyAnswered = Session.get "correctly answered"
    currentModule = modulesSequence[index]
    
    module = undefined

    if correctlyAnswered.length == modulesSequence.length
      Meteor.user().updateLessonsComplete(currLesson)
      Router.go "home"
      return

    if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
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

Template.nextBtn.helpers
  isLastModule: ()->
    return isLastModule()

  isHidden: ()->
    return Session.get "next button is hidden"

hasAllCorrectAnswers = ()->
  incorrectlyAnswered = Session.get "incorrectly answered"
  return incorrectlyAnswered.length <= 0

isAQuestion = (module)->
  return module.type == "SCENARIO" or module.type=="BINARY" or module.type=="MULTIPLE_CHOICE" or module.type == "GOAL_CHOICE"

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

