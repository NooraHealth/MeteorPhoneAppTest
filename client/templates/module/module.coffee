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


