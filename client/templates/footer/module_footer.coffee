Template.moduleFooter.helpers

  restOfDocs: ()->
    if !@.modules
      return

    rest = (module for module, index in @.modules when index != 0)
    return rest
  
  modules: ()->
    modules = Session.get "modules sequence"
    if !modules?
      return
    arr = ({module: module, i: i} for module, i in modules)
    return arr

  correctlyAnswered: (index)->
    return index in Session.get "correctly answered"

  incorrectlyAnswered: (index)->
    return index in Session.get "incorrectly answered"

  currentModule: ()->
    currentModuleIndex = Session.get "current module index"
    
    if !currentModuleIndex?
      return @.i == 0
    else
      return @.i == currentModuleIndex

Template.footer.onRendered ()->
  fview = FView.from this
  surface = fview.view or fview.surface
  surface.setProperties {zIndex: 12}

Template.moduleFooter.onRendered ()->
  fview = FView.from this
  surface = fview.view or fview.surface
  surface.setProperties {zIndex: 12}

  this.autorun ()->
    moduleSequence = Session.get "modules sequence"
    currentModuleIndex = Session.get "current module index"
    
    if currentModuleIndex?
      currentActiveNav = $(".module-navigation-bar").find("li[name="+ currentModuleIndex+"]")
      currentlyActive = $(".module-navigation-bar").find(".current")[0]
      if currentlyActive?
        currentlyActive.removeClass "current"
      currentActiveNav.addClass "current"
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
 







