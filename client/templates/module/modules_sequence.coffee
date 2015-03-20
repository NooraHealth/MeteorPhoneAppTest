Template.ModulesSequence.helpers
  modules: ()->
    if _.isEmpty @
      return []
    else
      if @.lesson
        moduleSequence = @.lesson.getModulesSequence()
        console.log "modules: ", moduleSequence
        Session.set "module sequence", moduleSequence
        Session.set "current module index", 0
        return moduleSequence

  currentModuleID: (nh_id)->
    index = Session.get "current module index"
    sequence = Session.get "module sequence"
    module = sequence[index]
    return module.nh_id == nh_id

####
## Tracks the current module in the series and
## moves the current module into visibility when the current module changes
####

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
  
