###
# Lesson
#
# A lesson is a collection of modules, and may or 
# may not contain sublessons
###

LessonSchema = new SimpleSchema
  title:
    type:String
  description:
    type:String
    optional:true
  icon:
    type: String
    #regEx:  /^([/]?\w+)+[.]png/
    optional:true
  image:
    type: String
    #regEx:  /^([/]?\w+)+[.]png/
    optional:true
  tags:
    type:[String]
    minCount:0
    optional:true
  modules:
    type: [String]
    optional:true
  first_module:
    type: String
  nh_id:
    type:String
    optional: true
    min:0

Lessons.attachSchema LessonSchema

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


