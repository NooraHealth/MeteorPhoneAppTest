###
# Curriculum
#
# A single Noora Health curriculum for a condition.
###

#LessonsCurriculum = new Mongo.Collection("nh_home_pages");
Curriculums = require('../collections.coffee').Curriculums

CurriculumSchema = new SimpleSchema
  _id:
    type:String
  title:
    type:String
  contentSrc:
    type:String
    optional:true
  lessons:
    type:[String]
    minCount:1
  condition:
    type:String
    min:0

Curriculums.attachSchema CurriculumSchema

module.exports.CurriculumSchema = CurriculumSchema

