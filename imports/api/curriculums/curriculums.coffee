###
# Curriculum
#
# A single Noora Health curriculum for a condition.
###
#{ Lessons } = require('../lessons/lessons.coffee').Lessons
Lessons = require('../lessons/lessons.coffee').Lessons


Curriculums = new Mongo.Collection("nh_home_pages")

CurriculumSchema = new SimpleSchema
  title:
    type:String
  lessons:
    type:[String]
    minCount:1
  condition:
    type:String
    min:0

Curriculums.attachSchema CurriculumSchema

Curriculums.helpers
  getLessonDocuments: ->
    return ( Lessons.findOne {_id: id} for id in @lessons)

Ground.Collection Curriculums

module.exports.Curriculums = Curriculums

