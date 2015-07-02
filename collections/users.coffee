Meteor.users.helpers {
  curriculumIsSet: ()->
    console.log "Getting whether the curriculum is set: "
    console.log Curriculum.find({}).count()
    curriculum = Curriculum.findOne {_id: @.profile.curriculumId}
    return curriculum?

  getCurriculumId: ()->
    return @.profile.curriculumId

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
    console.log "Is content Loaded: ", @.profile.content_loaded
    #return false
    return @.profile.content_loaded

  getCompletedLessons: ()->
    curr = @.getCurriculum()
    if !curr
      return []
    curriculum = curr.lessons
    if !curriculum
      return []
    usersCompletedLessons = @.profile.lessons_complete
    if !usersCompletedLessons
      return []
    return (lesson for lesson in usersCompletedLessons when lesson in curriculum)
  
  hasCompletedLesson: (_id)->
    lessonsComplete = @.getCompletedLessons()
    return _id in lessonsComplete
}
