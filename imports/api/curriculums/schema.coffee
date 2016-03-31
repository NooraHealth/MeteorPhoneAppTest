###
# Curriculum
#
# A single Noora Health curriculum for a condition.
###

#Curriculum = new Mongo.Collection("nh_home_pages");

CurriculumSchema = new SimpleSchema
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
  nh_id:
    optional:true
    type:String
    min:0

Curriculums.attachSchema CurriculumSchema

