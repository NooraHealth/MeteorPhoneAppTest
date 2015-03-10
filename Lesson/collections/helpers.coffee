Lessons.helpers {
  getSublessonDocuments: ()->
    
    if !this.has_sublessons
      throw new Meteor.error "malformed-document", "Your curriculum object
        does not contain a properly formed lessons field."

    lessons = []
    _.each this.lessons, (lessonID) ->
      lesson = Lessons.findOne {nh_id: lessonID}
      if lesson
        lessons.push lesson

    return lessons
}
