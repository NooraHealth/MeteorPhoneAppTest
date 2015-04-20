###
# MODULES SEQUENCE HELPERS
###

Template.Module.helpers
  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Tracker.autorun ()->
  modules = Session.get "modules sequence"
  if !modules?
    return

  currentModule = modules[Session.get "current module index"]
  if !currentModule?
    return

  if currentModule.type == "SLIDE"
    Session.set "next button is hidden", false
  if currentModule.type == "VIDEO"
    Session.set "next button is hidden", false
  if currentModule.type == "BINARY"
    Session.set "next button is hidden", true
  if currentModule.type == "MULTIPLE_CHOICE"
    Session.set "next button is hidden", true
  if currentModule.type == "SCENARIO"
    Session.set "next button is hidden", true

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

