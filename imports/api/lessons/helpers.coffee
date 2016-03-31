
Lessons.helpers {
  imgSrc: ()->
    if not @.image
      return ""
    url = Meteor.getContentSrc()
    return url + @.image

  getModulesSequence: ()->
    if this.modules
      moduleDocs = ( Modules.findOne {_id: moduleId} for moduleId in @.modules )
      return moduleDocs

    else
      modules = []

      module = @.getFirstModule()
      modules.push module
      until module.isLastModule()
        module = module.nextModule()
        modules.push module
      return modules

}


