Meteor.users.helpers {
  curriculumIsSet: ()->
    if not @.profile or not @.profile.curriculumId
      return false
    curriculum = Curriculum.findOne {_id: @.profile.curriculumId}
    return curriculum?

  getCurriculum: ()->
    return Curriculum.findOne {_id: @.profile.curriculumId}

  setCurriculum: (id)->
    @.profile.curriculumId = id
    @

  setContentAsLoaded: ()->
    @.profile.content_loaded = true
    @

  contentLoaded: ()->
    return @.profile.content_loaded

  getCompletedChapters: ()->
    return @.profile.chapters_complete
}
