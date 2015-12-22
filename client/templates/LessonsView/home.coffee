Template.lessonsView.helpers
  lessons: ()->
    currId = Session.get "curriculum id"
    curriculum = Curriculum.findOne {_id: currId }
    if curriculum
      return curriculum.getLessonDocuments()
    else
      return []

Template.lessonsView.onRendered ()->
  Scene.get().playAppIntro()
  currentLesson = Session.get "current lesson"
  card = $(".card-footer")[currentLesson]
  if currentLesson > 0 and card
    $(card).scrollintoview {
      duration: 2500,
      direction: "vertical"
    }

