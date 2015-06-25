Meteor.users.helpers {
  curriculumIsSet: ()->
    curriculum = Curriculum.findOne {_id: @.profile.curriculumId}
    return curriculum?

  getCurriculum: ()->
    return Curriculum.findOne {_id: @.profile.curriculumId}

  setCurriculum: (id)->
    oldCurriculum = @.profile.curriculumId
    if @.profile.curriculumId == id
      return
    else
      query = { $set: {"profile.curriculumId": id}}
      Meteor.call "updateUser", query
      #after setting the curriculum, indicate that the
      #new content will need to be loaded
      @.setContentAsLoaded(false)
    @

  setContentAsLoaded: (loaded)->
    query = { $set: {"profile.content_loaded": loaded}}
    Meteor.call "updateUser", query
    @

  updateLessonsComplete: (lesson)->
    lessonsComplete = @.getCompletedLessons()
    if lesson.nh_id not in lessonsComplete
      console.log "PUshing the lesson to the user"
      query = {$push: {"profile.lessons_complete": lesson.nh_id}}
      Meteor.call "updateUser", query
    @

  contentLoaded: ()->
    return @.profile.content_loaded

  getCompletedLessons: ()->
    curriculum = @.getCurriculum().lessons
    usersCompletedLessons = @.profile.lessons_complete
    return (lesson for lesson in usersCompletedLessons when lesson in curriculum)
  
  hasCompletedLesson: (_id)->
    lessonsComplete = @.getCompletedLessons()
    return _id in lessonsComplete
}
