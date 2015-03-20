Template.moduleFooter.helpers
  modules: ()->
    modules = Session.get "module sequence"
    if !modules?
      return
    arr = ({module: module, i: i} for module, i in modules)
    console.log arr
    return arr

  currentModule: ()->
    moduleSequence = Session.get "module sequence"
    if !moduleSequence?
      return ""

    currentModuleIndex = Session.get "current module index"
    #currentModule = moduleSequence[currentModuleIndex]
    if !currentModuleIndex?
      firstModule = moduleSequence[0]
      return @.index == 0
    else
      return @.index = currentModuleIndex

Template.moduleFooter.events
  'click [name=module_nav]': (event, template) ->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    Session.set "previous module index", currentIndex
    nextModule = event.target.find('a').attr 'name'
    console.log nextModule
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
  moduleSequence = Session.get "module sequence"
  currentModuleIndex = Session.get "current module index"
  previousModuleIndex = Session.get "previous module index"

  if currentModuleIndex?
    currentModule = moduleSequence[currentModuleIndex]
    currentActiveNav = $(".module-navigation-bar").find("li[name="+ currentModule.nh_id+"]")
    currentActiveNav.addClass "current"
  
  if previousModuleIndex?
    previousModule = moduleSequence[previousModuleIndex]
    previousActiveNav = $(".module-navigation-bar").find("li[name="+ previousModule.nh_id+"]")
    previousActiveNav.removeClass "current"

  
