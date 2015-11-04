Template.moduleFooter.helpers

  modules: ()->
    modules = Scene.get().getModulesSequence()

    if !modules?
      return
    arr = ({module: module, i: i} for module, i in modules)
    return arr

  completed: ( i )->
    if i < Scene.get().getModuleSequenceController().currentModuleIndex()
      return true
    else
      return false

  currentModule: ()->
    currentModuleIndex = Session.get "current module index"
    
    if !currentModuleIndex?
      return @.i == 0
    else
      return @.i == currentModuleIndex

