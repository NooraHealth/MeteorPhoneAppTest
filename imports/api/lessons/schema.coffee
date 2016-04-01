
Lessons = require('../collections.coffee').Lessons

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
