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

Curriculums.helpers {
  getLessonDocuments: ()->
    
    if not @lessons?
      throw new Meteor.error "malformed-document", "Your curriculum object
        does not contain a properly formed lessons field."

    lessons = []
    _.each @lessons, (lessonID) ->
      lesson = Lessons.findOne {_id: lessonID}
      console.log "This is the lesson", lesson
      if lesson?
        lessons.push lesson

    return lessons
}

Ground.Collection Curriculums

module.exports.Curriculums = Curriculums

