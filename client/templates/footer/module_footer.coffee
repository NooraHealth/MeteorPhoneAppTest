Template.moduleFooter.helpers
  modules: ()->
    modules = Session.get "module sequence"
    if !modules?
      return
    arr = ({module: module, i: i} for module, i in modules)
    return arr

  currentModule: ()->
    moduleSequence = Session.get "module sequence"
    if !moduleSequence?
      return ""

    currentModuleIndex = Session.get "current module index"
    if !currentModuleIndex?
      return @.i == 0
    else
      return @.i == currentModuleIndex

Template.moduleFooter.events
  'click .module_nav': (event, template) ->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "previous module index", currentIndex
    nextModule = $(event.target).attr 'name'
    Session.set "current module index", nextModule
  
  'click [name=next]': (event, template)->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "previous module index", currentIndex
    Session.set "current module index", ++currentIndex

  'click [name=previous]': ()->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "previous module index", currentIndex
    Session.set "current module index", --currentIndex
 
Tracker.autorun ()->
  console.log "going to adjust footer"
  moduleSequence = Session.get "module sequence"
  currentModuleIndex = Session.get "current module index"
  previousModuleIndex = Session.get "previous module index"

  if currentModuleIndex?
    currentModule = moduleSequence[currentModuleIndex]
    currentActiveNav = $(".module-navigation-bar").find("li[name="+ currentModule.nh_id+"]")
    console.log "current active nav: ", currentActiveNav
    currentActiveNav.addClass "current"
  
  if previousModuleIndex?
    previousModule = moduleSequence[previousModuleIndex]
    previousActiveNav = $(".module-navigation-bar").find("li[name="+ previousModule.nh_id+"]")
    previousActiveNav.removeClass "current"

  
