Lessons.helpers {
  getSublessonDocuments: ()->
    
    if !this.has_sublessons
      return []

    lessons = []
    _.each this.lessons, (lessonID) ->
      lesson = Lessons.findOne {nh_id: lessonID}
      if lesson
        lessons.push lesson

    return lessons
}
