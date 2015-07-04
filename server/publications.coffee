Meteor.publish "users", ()->
  return Meteor.users.find({})

Meteor.publish "modules", (lessonId)->
  if !lessonId
    return []
  lesson = Lessons.findOne {_id: lessonId}
  modules = lesson.modules
  return Modules.find {_id: {$in: modules}}

Meteor.publish "all_lessons", ()->
  return Lessons.find({})

Meteor.publish "all_curriculums", ()->
  return Curriculum.find({})

Meteor.publish "all_modules", ()->
  return Modules.find({})

Meteor.publish "curriculum", (id)->
  if id
    return Curriculum.find ({_id: id})

Meteor.publish "lessons", (curriculumId)->
  if curriculumId
    curr = Curriculum.findOne {_id: curriculumId}
    if !curr
      return []
    lessons = curr.lessons
    return Lessons.find {_id: {$in: lessons}}

Meteor.publish "lesson", (id)->
  return Lessons.find ({_id: id})

