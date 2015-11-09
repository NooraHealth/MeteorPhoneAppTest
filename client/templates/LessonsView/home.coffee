Template.lessonsView.helpers
  curriculumTitle: ()->
    return Scene.get().getCurriculum().title

  lessons: ()->
    return Scene.get().getLessons()

Template.lessonsView.onRendered ()->
  console.log "Scroll into view"
  currentLesson = Session.get "current lesson"
  console.log "current lesson", currentLesson
  card = $(".card-footer")[currentLesson]
  if card
    card.scrollIntoView()

