
{ Modules } = require '../modules/modules.coffee'
ContentInterface = require('../content/ContentInterface.coffee').ContentInterface

Lessons = new Mongo.Collection("nh_lessons")

LessonSchema = new SimpleSchema
  title:
    type:String
  icon:
    type: String
    optional:true
  image:
    type: String
    optional:true
  modules:
    type: [String]
    optional:true

Lessons.attachSchema LessonSchema

Lessons.helpers
  imgSrc: ->
    if not @image then "" else ContentInterface.get().getUrl @image

  getModulesSequence: ()->
    if @modules
      return ( Modules.findOne {_id: moduleId} for moduleId in @modules )

Ground.Collection Lessons

module.exports.Lessons = Lessons
