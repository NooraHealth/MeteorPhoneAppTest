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

Meteor.publish "all_curriculums", ()->
  return Curriculum.find({})

Meteor.publish "all_modules", ()->
  return Modules.find({})

Meteor.publish "curriculum", (id)->
  console.log "Returning the curriculum"
  if id
    return Curriculum.find ({_id: id})

Meteor.publish "lessons", (curriculumId)->
  console.log "Returning the lessons"
  if curriculumId
    curr = Curriculum.findOne {_id: curriculumId}
    if !curr
      return []
    lessons = curr.lessons
    console.log "Lessons to return: ", lessons
    console.log Lessons.find({_id: {$in: lessons}}).count()
    return Lessons.find {_id: {$in: lessons}}

Meteor.publish "lesson", (id)->
  return Lessons.find ({_id: id})

