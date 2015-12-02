Meteor.publish "users", ()->
  return Meteor.users.find({})

Meteor.publish "all", ()->
  return [
    Meteor.users.find({}),
    Curriculum.find({}),
    Modules.find({}),
    Lessons.find({}),
  ]

Meteor.publish "modules", (lessonId)->
  if !lessonId
    return []
  lesson = Lessons.findOne {_id: lessonId}
  modules = lesson.modules
  console.log Modules.find({_id: {$in: modules}}).count()
  return Modules.find {_id: {$in: modules}}

Meteor.publish "all_lessons", ()->
  return Lessons.find({})
#Meteor.publish "attempts", (userId)->
  #return Attempts.find({})

Meteor.publish "curriculums", ()->
  console.log "Returning curriculums"
  return Curriculum.find({})

Meteor.publish "modules_in_curriculum", ( currId )->
  curr = Curriculum.findOne { _id: currId }
  console.log curr
  modules = []
  if curr
    for lesson in curr.getLessonDocuments()
      for module in lesson.modules
        modules.push module

    console.log Modules.find({ _id: {$in: modules }}).count()
    return Modules.find { _id: {$in: modules }}

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

