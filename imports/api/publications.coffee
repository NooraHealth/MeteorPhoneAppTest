
Curriculums = require('./curriculums/curriculums.coffee').Curriculums
Lessons = require('./lessons/lessons.coffee').Lessons
Modules = require('./modules/modules.coffee').Modules

Meteor.publish "modules.inLesson", (lessonId) ->
  if !lessonId then return []
  lesson = Lessons.findOne {_id: lessonId}
  return Modules.find {_id: {$in: lesson.modules}}

Meteor.publish "curriculums.all", ->
  return Curriculums.find({})

Meteor.publish "curriculum", (id) ->
  if id then Curriculums.find ({_id: id}) else []

Meteor.publish "lessons.inCurriculum", (curriculumId) ->
  if curriculumId
    curr = Curriculums.findOne {_id: curriculumId}
    if curr? then return Lessons.find {_id: {$in: curr.lessons}} else []
  else
    return []

Meteor.publish "lesson", (id) ->
  return Lessons.find ({_id: id})

