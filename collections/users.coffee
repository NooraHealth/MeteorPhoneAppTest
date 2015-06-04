Meteor.users.helpers {
  curriculumIsSet: ()->
    if not @.profile or not @.profile.curriculumId
      return false
    curriculum = Curriculum.findOne {_id: @.profile.curriculumId}
    return curriculum?

  getCurriculum: ()->
    return Curriculum.findOne {_id: @.profile.curriculumId}

  setCurriculum: (id)->
    Meteor.users.update {_id: @._id}, { $set: {"profile.curriculumId": id}}
    @

  setContentAsLoaded: (loaded)->
    Meteor.users.update {_id: @._id}, { $set: {"profile.content_loaded": loaded}}
    @

  contentLoaded: ()->
    return @.profile.content_loaded

  getCompletedChapters: ()->
    return @.profile.chapters_complete
}
