###
# Curriculum
#
# A single Noora Health curriculum for a condition.
###

#Curriculum = new Mongo.Collection("nh_home_pages");

CurriculumSchema = new SimpleSchema
  title:
    type:String
  lessons:
    type:[String]
    minCount:1
  condition:
    type:String
    min:0
  nh_id:
    type:String
    min:0

Curriculum.attachSchema CurriculumSchema
