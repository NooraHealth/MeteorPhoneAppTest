Meteor.users.helpers {
  curriculumIsSet: ()->
    if not @.profile or not @.profile.curriculumId
      return false
    curriculum = Curriculum.findOne {_id: @.profile.curriculumId}
    return curriculum?

  getCurriculum: ()->
    return Curriculum.findOne {_id: @.profile.curriculumId}

  setCurriculum: (id)->
    query = { $set: {"profile.curriculumId": id}}
    Meteor.call "updateUser", query
    @

  setContentAsLoaded: (loaded)->
    query = { $set: {"profile.content_loaded": loaded}}
    Meteor.call "updateUser", query
    @

  contentLoaded: ()->
    return false
    #return @.profile.content_loaded

  getCompletedChapters: ()->
    return @.profile.chapters_complete
  
  hasCompletedChapter: (_id)->
    chaptersComplete = @.getCompletedChapters()
    return _id in chaptersComplete
}
