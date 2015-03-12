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
      modules.push module
      until module.isLastModule()
        module = module.nextModule()
        modules.push module

      console.log "Got the modules!", modules
      return modules

  getFirstModule: ()->
    return Modules.findOne {nh_id: @.first_module}

  hasSublessons: ()->
    if @.has_sublessons
      return @.has_sublessons == 'true'
    else
      return false

  imgSrc: ()->
    return MEDIA_URL + @.image
}
