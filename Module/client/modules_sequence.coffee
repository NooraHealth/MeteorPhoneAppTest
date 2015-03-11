Template.ModulesSequence.helpers
  modules: ()->
    if _.isEmpty @
      return []
    else
      if @.lesson
        return @.lesson.getModulesSequence()
