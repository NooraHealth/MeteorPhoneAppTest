###
# MODULES SEQUENCE HELPERS
###

Template.Module.helpers
  #module: ()->
    #if @
      #return @.moduleDocs[Session.get "current module index"]

  getTemplate: ()->
    type = Session.get "current template type"
    if @
      if type == "SLIDE"
        return "slideModule"
      if type == "VIDEO"
        return "videoModule"
      if type == "BINARY"
        return "binaryChoiceModule"
      if type == "MULTIPLE_CHOICE"
        return "multipleChoiceModule"
      if type == "SCENARIO"
        return "scenarioModule"

  #currentModuleID: (nh_id)->
    #index = Session.get "current module index"
    #sequence = @.modules
    #if !index? or !sequence?
      #return
    #module = sequence[index]
    #return module.nh_id == nh_id


Template.Module.onRendered ()->
  fview = FView.byId "module"
  surface = fview.view or fview.surface
  console.log "this is the fview: ", fview

  #Move the surface to the back of the screen
  surface.setProperties {zIndex: -1}

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

