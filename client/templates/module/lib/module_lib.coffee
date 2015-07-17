
this.allModulesComplete = ()->
  numModules = (Session.get "modules sequence").length
  numCorrect = (Session.get "correctly answered").length
  currentModule = getCurrentModule()
  if !currentModule
    return false
  if ModuleSurface.isAQuestion(currentModule)
    return numCorrect == numModules
  else
    return numCorrect == numModules - 1

#this.updateModuleNav = (responseStatus)->
  #moduleIndex = Session.get "current module index"
  #correctAnswers = Session.get "correctly answered"
  #incorrectlyAnswered = Session.get "incorrectly answered"

  #if responseStatus == "correct"
    #if moduleIndex in correctAnswers
      #return
    ##Remove the index from the array of incorrect answers
    #if moduleIndex in incorrectlyAnswered
      #incorrectlyAnswered = incorrectlyAnswered.filter (i) -> i isnt moduleIndex
      #Session.set "incorrectly answered", incorrectlyAnswered
    #correctAnswers.push Session.get "current module index"
    #Session.set "correctly answered", correctAnswers

  #if responseStatus == "incorrect"
    #if moduleIndex in incorrectlyAnswered
      #return
    #incorrectlyAnswered.push Session.get "current module index"
    #Session.set "incorrectly answered", incorrectlyAnswered

this.nextBtnShouldHide = ()->
  currentModule = this.getCurrentModule()
  if !currentModule
    return
  if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
    return false
  else
    #return Session.get "next button is hidden"
    return true
###
# Stop all module media and prepare to show the next module
#
# previousModule        The module to clear, in preparation for the next module
###

this.resetModules = (previousModule) ->
  nh_id = previousModule.nh_id

  ModuleView.stopAllAudio()
  
  #Hide the stickers
  $("#sticker_incorrect").addClass "hidden"
  $("#sticker_correct").addClass "hidden"
  

###
# Go to the next module in the sequence
###
this.goToNext = ()->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    resetModules(moduleSequence[currentIndex])

    if currentIndex == moduleSequence.length - 1
      goBackToChapterPage()
      Session.set "previous module index", currentIndex
      Session.set "current module index", null
    else
      Session.set "previous module index", currentIndex
      Session.set "current module index", ++currentIndex

###
# Go to the previous module in the sequence
###
this.goToPreviousModule = () ->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    resetModules(moduleSequence[currentIndex])
    
    Session.set "previous module index", currentIndex
    Session.set "current module index", --currentIndex

###
# Show the button that leads to the next module
#
# module        The module on which to show the "next" button
###

this.showNextModuleBtn = (module) ->
  $("#nextbtn").fadeIn()
  Session.set "next button is hidden", false

this.getCurrentModule = ()->
  moduleSequence = Session.get "modules sequence"
  currentIndex = Session.get "current module index"
  if !moduleSequence or !currentIndex
    return

  return moduleSequence[currentIndex]
