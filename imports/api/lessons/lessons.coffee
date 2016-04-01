
{ Modules } = require '../modules/modules.coffee'

Lessons = new Mongo.Collection("nh_lessons")

LessonSchema = new SimpleSchema
  title:
    type:String
  icon:
    type: String
    #regEx:  /^([/]?\w+)+[.]png/
    optional:true
  image:
    type: String
    #regEx:  /^([/]?\w+)+[.]png/
    optional:true
  modules:
    type: [String]
    optional:true

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

Ground.Collection Lessons

module.exports.Lessons = Lessons
