###
# MODULES SEQUENCE HELPERS
###

Template.Module.helpers
  module: ()->
    if @
      return @.moduleDocs[Session.get "current module index"]

  getTemplate: ()->
    console.log "getting the current module!!"
    console.log ""
    console.log ""
    currentModule = getCurrentModule()
    console.log "returning the template fr: ", currentModule
    if currentModule.type == "SLIDE"
      return "slideModule"
    if currentModule.type == "VIDEO"
      return "videoModule"
    if currentModule.type == "BINARY"
      return "binaryModule"
    if currentModule.type == "MULTIPLE_CHOICE"
      return "multipleChoiceModule"
    if currentModule.type == "SCENARIO"
      return "scenarioModule"

  currentModuleID: (nh_id)->
    index = Session.get "current module index"
    sequence = @.modules
    if !index? or !sequence?
      return
    module = sequence[index]
    return module.nh_id == nh_id


###
# MODULES SEQUENCE EVENTS
###
Template.Module.events
  'click .response': (event, template)->
    response = $(event.target).val()
    moduleSequence = @.modules
    currentModuleIndex = Session.get "current module index"
    module = moduleSequence[currentModuleIndex]

    hideIncorrectResponses(module)
    
    if correctResponse(event.target)
      #showSticker "correct", module
      playAnswerAudio "correct", module
      handleSuccessfulAttempt(module, 0)
    else
      #showSticker "incorrect", module
      playAnswerAudio "incorrect", module
      handleFailedAttempt module, [$(event.target).attr "value"], 0

    showNextModuleBtn(module)

  'click [name=next]': (event, template) ->
    module = currentModule()
    if module.type == "VIDEO" or module.type == "SLIDE"
      handleSuccessfulAttempt(module, 0)

    goToNext()

###
# AUTORUN
# 
# Tracks the current module in the series and
# moves the current module into visibility when the current module changes
###

Tracker.autorun ()->
  moduleSequence = Session.get "module sequence"
  currentModuleIndex = Session.get "current module index"
  previousModuleIndex = Session.get "previous module index"
  
  if !moduleSequence or !moduleSequence?
    return

  if currentModuleIndex?
    moduleToDisplay = $("#module"+ moduleSequence[currentModuleIndex].nh_id)
    moduleToDisplay.addClass 'visible-module'
    moduleToDisplay.removeClass 'hidden-left'
  
  if previousModuleIndex?
    moduleToHide = $("#module" + moduleSequence[previousModuleIndex].nh_id)
    moduleToHide.removeClass 'visible-module'
    moduleToHide.addClass 'hidden-left'

###
# HELPER FUNCTIONS
###

#showSticker = (response, module) ->
  #nh_id = module.nh_id
  
  #if $(response).hasClass "correct"
    #$("#sticker_correct").removeClass("hidden")
  #else
    #console.log "showing red sticked"
    #$("#sticker_incorrect").removeClass("hidden")

correctResponse = (response) ->
  return $(response).hasClass "correct"

hideIncorrectResponses = (module)->
    nh_id = module.nh_id
    responseBtns =  $("a[name=#{nh_id}]")
    for btn in responseBtns
      if not $(btn).hasClass "correct"
        if $(btn).hasClass "response"
          $(btn).hide()
      else
        $(btn).addClass "disabled"
        $(btn).removeClass "response"
        console.log "making this button disabled: ", btn

