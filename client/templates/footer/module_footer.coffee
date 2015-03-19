Template.moduleFooter.helpers
  modules: ()->
    return Session.get "module sequence"

  currentModule: ()->
    moduleSequence = Session.get "module sequence"
    if !moduleSequence?
      return ""

    currentModuleIndex = Session.get "current module index"
    currentModule = moduleSequence[currentModuleIndex]
    if !currentModuleIndex?
      firstModule = moduleSequence[0]
      return @.nh_id == firstModule.nh_id
    else
      return @.nh_id == currentModule.nh_id

Template.moduleFooter.events
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
    #if !currentActiveNav.length
      #console.log "filling the nav list"
      #fillNavList()
    #else
    currentActiveNav.addClass "current"
  
  if previousModuleIndex?
    previousModule = moduleSequence[previousModuleIndex]
    previousActiveNav = $(".module-navigation-bar").find("li[name="+ previousModule.nh_id+"]")
    previousActiveNav.removeClass "current"

#fillNavList = ()->
  #modules = Session.get "module sequence"
  #if !modules?
    #return ""

  #list = ""
  #for module, index in modules
    #if index == 0
      #list += "<li class='current' name="+module.nh_id+"><a>"+module.nh_id+"</a></li>"
    #else
      #list += "<li class='' name="+module.nh_id+"><a>"+module.nh_id+"</a></li>"
  
  #(".module-navigation-bar").find("ul").html list

  
