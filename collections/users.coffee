Meteor.users.helpers {
  curriculumIsSet: ()->
    return @.profile.curriculumId?

  getCurriculum: ()->
    return Curriculum.findOne {_id: @.profile.curriculumId}

  setCurriculum: (curriculum)->
    @.profile.curriculumId = curriculum._id
    @

  setContentAsLoaded: ()->
    @.profile.content_loaded = true
    @

  contentLoaded: ()->
    return @.profile.content_loaded

  getCompletedChapters: ()->
    return @.profile.chapters_complete
}
