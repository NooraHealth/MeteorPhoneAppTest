Template.lessonsView.helpers
  lessons: ()->
    currId = Session.get "curriculum id"
    curriculum = Curriculum.findOne {_id: currId }
    if curriculum
      return curriculum.getLessonDocuments()
    else
      return []

Template.lessonsView.onRendered ()->
  console.log "Scroll into view"
  currentLesson = Session.get "current lesson"
  console.log "current lesson", currentLesson
  card = $(".card-footer")[currentLesson]
  if currentLesson > 0 and card
    $(card).scrollintoview {
      duration: 2500,
      direction: "vertical"
    }

