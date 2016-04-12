
Curriculums = require('./curriculums/curriculums.coffee').Curriculums
Lessons = require('./lessons/lessons.coffee').Lessons
Modules = require('./modules/modules.coffee').Modules

Meteor.publish "modules.inLesson", (lessonId) ->
  console.log "returning modules in lesson", lessonId
  if !lessonId then return []
  lesson = Lessons.findOne {_id: lessonId}
  modules = lesson.modules
  console.log modules
  console.log Modules.find {_id: {$in: modules}}
  return Modules.find {_id: {$in: modules}}

Meteor.publish "all_curriculums", ()->
  console.log "AL CUURR"
  return Curriculum.find({})

Meteor.publish "all_modules", ()->
  return Modules.find({})

Meteor.publish "all_lessons", ()->
  return Lessons.find({})

Meteor.publish "curriculums", ()->
  console.log "Returning curriculums"
  console.log Curriculum.find({}).count()
  return Curriculum.find({})

Meteor.publish "modules_in_curriculum", ( currId )->
  curr = Curriculum.findOne { _id: currId }
  console.log curr
  modules = []
  if not curr
    return []
  else
    for lesson in curr.getLessonDocuments()
      for module in lesson.modules
        modules.push module
      console.log Modules.find({ _id: {$in: modules }}).count()
      return Modules.find { _id: {$in: modules }}

Meteor.publish "curriculum", (id)->
  if id
    return Curriculum.find ({_id: id})
  else
    return []

Meteor.publish "lessons", (curriculumId)->
  if curriculumId
    curr = Curriculum.findOne {_id: curriculumId}
    if !curr
      return []
    lessons = curr.lessons
    return Lessons.find {_id: {$in: lessons}}
  else
    return []

Meteor.publish "lesson", (id)->
  console.log "Publishing the lesson", id
  console.log Lessons.find ({_id: id})
  return Lessons.find ({_id: id})

