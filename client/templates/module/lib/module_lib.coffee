
this.allModulesComplete = ()->
  numModules = (Session.get "modules sequence").length
  numCorrect = (Session.get "correctly answered").length
  currentModule = getCurrentModule()
  if !currentModule
    return false
  if isAQuestion(currentModule)
    return numCorrect == numModules
  else
    return numCorrect == numModules - 1

this.isAQuestion = (module)->
  return module.type == "SCENARIO" or module.type=="BINARY" or module.type=="MULTIPLE_CHOICE" or module.type == "GOAL_CHOICE"

this.stopAllAudio = ()->
  for audioElem in $("audio")
    audioElem.pause()

this.buttonDisabled = (btn)->
  return $(btn).hasClass('faded') or $(btn).hasClass('expanded')

this.handleResponse = (response)->
  moduleSequence = Session.get "modules sequence"
  currentModuleIndex = Session.get "current module index"
  module = moduleSequence[currentModuleIndex]
  id = module._id

  if module.type != "MULTIPLE_CHOICE"
    hideIncorrectResponses(module)
  
  if isCorrectResponse(event.target, module)
    if module.type != "MULTIPLE_CHOICE"
      displayToast "correct"
    playAudio "correct",id
    handleSuccessfulAttempt(module, 0)
    updateModuleNav "correct"
  else
    if module.type != "MULTIPLE_CHOICE"
      displayToast "incorrect"
    playAudio "incorrect",id
    handleFailedAttempt module, [$(event.target).attr "value"], 0
    updateModuleNav "incorrect"

  showNextModuleBtn()

this.displayToast = (type)->
  if Meteor.Device.isPhone()
    if type=="correct"
      Session.set "success toast is visible", true
    else
      Session.set "fail toast is visible", true
  else
    classes = "left valign rounded"
    if type=="correct"
      Materialize.toast "<i class='mdi-navigation-check medium'></i>", 5000, classes+ " green"
    else
      Materialize.toast "<i class='mdi-navigation-close medium'></i>", 5000, classes+ " red"

this.hideIncorrectResponses = ()->
  responseBtns =  $(".response")
  for btn in responseBtns
    if not $(btn).hasClass "correct"
      $(btn).addClass "faded"
      
    else
      $(btn).addClass "z-depth-2"
      $(btn).addClass "expanded"
    $(btn).unbind "click"

this.updateModuleNav = (responseStatus)->
  moduleIndex = Session.get "current module index"
  correctAnswers = Session.get "correctly answered"
  incorrectlyAnswered = Session.get "incorrectly answered"

  if responseStatus == "correct"
    if moduleIndex in correctAnswers
      return
    #Remove the index from the array of incorrect answers
    if moduleIndex in incorrectlyAnswered
      incorrectlyAnswered = incorrectlyAnswered.filter (i) -> i isnt moduleIndex
      Session.set "incorrectly answered", incorrectlyAnswered
    correctAnswers.push Session.get "current module index"
    Session.set "correctly answered", correctAnswers

  if responseStatus == "incorrect"
    if moduleIndex in incorrectlyAnswered
      return
    incorrectlyAnswered.push Session.get "current module index"
    Session.set "incorrectly answered", incorrectlyAnswered

this.isCorrectResponse = (response, module) ->
  if module.type == "MULTIPLE_CHOICE"
    numPossibleCorrect = module.correct_answer.length
    #fade out all the containers of the incorrect options
    [responses, numIncorrect] = expandCorrectOptions(module)

    if numIncorrect > 0
      return false
    else
      return true
  else
    return $(response).hasClass "correct"

expandCorrectOptions = (module) ->
    id = module._id
    options = $("#"+id).find("img[name=option]")
    responses = []
    numIncorrect = 0
    for option in options
      #if $(option).hasClass "selected"
        #responses.push $(option).attr "name"
      if not $(option).hasClass "correct"
        $(option).addClass "faded"
      
      else
        $(option).addClass "expanded"
        
        if not $(option).hasClass "selected"
          numIncorrect++
          $(option).addClass "incorrectly_selected"

        else
        $(option).removeClass "selected"
        $(option).addClass "correctly_selected"

    return [responses, numIncorrect]

#
###
# Handler for all failed attempts on a module
#
# - Inserts a failed attempt into the Attempts collection
# - Appends this module to the module sequence for the user to 
# try again.
#
# module            Module document object 
# responses         user's incorrect response
# time_to_complete  the time to complete the module in ms
###
this.handleFailedAttempt = (module, responses, time_to_complete) ->
  #Attempts.insert {
    #user: Meteor.user()._id
    #responses: responses
    #passed: false
    #date: new Date().getTime()
    #nh_id: module.nh_id
  #}, (error, _id) ->
    #if error
      #console.log "There was an error inserting the incorrect attempt into the database", error
    #else
      #console.log "Just inserted this incorrect attempt into the DB: ", Attempts.findOne {_id: _id}


###
# Handler for all successful attempts on a module
#
# -Inserts a successful attempt into the Attempts collection
#
# module            Module document object 
# responses         user's incorrect response
# time_to_complete  time to complete the module in ms
###
this.handleSuccessfulAttempt = (module, time_to_complete)->
  #Attempts.insert {
    #user: Meteor.user()._id
    #passed: true
    #date: new Date().getTime()
    #nh_id: module.nh_id
  #}, (error, _id) ->
    #if error
      #console.log "There was an error inserting the CORRECT attempt into the database"
    #else
      #console.log "Just inserted this CORRECT attempt into the DB: ", Attempts.findOne {_id: _id}


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
# Plays the audio associated with the answer
#
# type      Either "correct" or "incorrect"
# module    The module to play the answer audio for
###
this.playAudio = (type, id)->
  module = Modules.findOne {_id: id}
  #elem = $("audio[name=audio#{nh_id}][class=question]")[0]
  #if elem and type =="question"
    #elem.play()
    #return
  #else if elem
    #elem.currentTime = 0
    #elem.pause()

  if type == "question"
    src = module.audioSrc()
  else if type == "correct"
    #elem =  $("audio[name=audio#{nh_id}][class=correct]")[0]
    src = module.correctAnswerAudio()
  else if type == "incorrect"
    #elem =  $("audio[name=audio#{nh_id}][class=incorrect]")[0]
    src = module.incorrectAnswerAudio()
  else
    src=""
  elem = $('#toplay')
  elem.attr('src',  src)
  elem[0].addEventListener "canplay", ()->
    elem[0].currentTime = 0
    elem[0].play()
  , true
#
###
# Stop all module media and prepare to show the next module
#
# previousModule        The module to clear, in preparation for the next module
###

this.resetModules = (previousModule) ->
  nh_id = previousModule.nh_id

  #Pause all playing audio
  audioArr = $("audio[name=audio#{nh_id}]")
  for audioElem in audioArr
    $(audioElem)[0].pause()

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

###
# Go back to the chapter page of the current chapter
###
this.goBackToChapterPage = ()->
  currentChapter = Session.get "current chapter"
  Router.go "/chapter/"  + currentChapter.nh_id

this.getCurrentModule = ()->
  moduleSequence = Session.get "modules sequence"
  currentIndex = Session.get "current module index"
  if !moduleSequence or !currentIndex
    return

  return moduleSequence[currentIndex]
