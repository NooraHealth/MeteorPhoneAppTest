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
      next_module = @.first_module
      while next_module != '-1'
        module = Modules.findOne {nh_id: next_module}
        modules.push module
        next_module = module.next_module

      return modules
}
