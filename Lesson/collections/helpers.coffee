Lessons.helpers {
  getSublessonDocuments: ()->
    
    if !this.has_sublessons
      return []

    lessons = []
    _.each this.lessons, (lessonID) ->
      lesson = Lessons.findOne {nh_id: lessonID}
      if lesson
        lessons.push lesson

    return lessons

  getModulesSequence: ()->
    if !this.first_module
      Meteor.Error "This lesson does not have any modules"

    else
      modules = []
      module = @.getFirstModule()
      while !module.isLastModule()
        modules.push module
        module = module.nextModule()

      return modules

  getFirstModule: ()->
    return Modules.findOne {nh_id: @.first_module}
}
