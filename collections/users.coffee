Meteor.users.helpers {
  curriculumIsSet: ()->
    console.log "Entering user curriculum is Set helper"
    if not @.profile or not @.profile.curriculumId
      return false
    curriculum = Curriculum.findOne {_id: @.profile.curriculumId}
    console.log "Is the curriculum set? In the user helper: ", curriculum
    return curriculum?

  getCurriculum: ()->
    return Curriculum.findOne {_id: @.profile.curriculumId}

  setCurriculum: (id)->
    query = { $set: {"profile.curriculumId": id}}
    console.log "upading the users curriculum"
    console.log query
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
