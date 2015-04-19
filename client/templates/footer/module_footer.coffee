Template.moduleFooter.helpers
  modules: ()->
    modules = Session.get "modules sequence"
    if !modules?
      return
    arr = ({module: module, i: i} for module, i in modules)
    return arr

  currentModule: ()->

    currentModuleIndex = Session.get "current module index"
    console.log "this is the currnet module index", currentModuleIndex
    console.log @
    console.log @.i
    console.log @.i == currentModuleIndex
    if !currentModuleIndex?
      return @.i == 0
    else
      return @.i == currentModuleIndex

#Template.moduleFooter.events
  #'click .module_nav': (event, template) ->
    #currentIndex = Session.get "current module index"
    #moduleSequence = Session.get "module sequence"
    #resetModules(moduleSequence[currentIndex])
    
    #Session.set "previous module index", currentIndex
    #nextIndex = $(event.target).attr 'name'
    #if nextIndex == currentIndex
      #return
    #else
      #Session.set "current module index", nextIndex

  #'click [name=next]': (event, template)->
    #goToNextModule(event, template)

  #'click [name=previous]': (event, template)->
    #goToPreviousModule(event, template)
 
Tracker.autorun ()->
  moduleSequence = Session.get "modules sequence"
  currentModuleIndex = Session.get "current module index"
  
  if currentModuleIndex?
    currentActiveNav = $(".module-navigation-bar").find("li[name="+ currentModuleIndex+"]")
    currentlyActive = $(".module-navigation-bar").find(".current")[0]
    if currentlyActive?
      currentlyActive.removeClass "current"
    currentActiveNav.addClass "current"




