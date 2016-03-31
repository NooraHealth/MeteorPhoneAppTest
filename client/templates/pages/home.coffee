Template.Home_page.helpers
  lessons: ()->
    currId = Session.get "curriculum id"
    curriculum = Curriculums.findOne {_id: currId }
    if curriculum
      return curriculum.getLessonDocuments()
    else
      return []

Template.Home_page.onRendered ()->
  console.log "About to play app intro"
  Scene.get().playAppIntro()
  currentLesson = Session.get "current lesson"
  card = $(".card-footer")[currentLesson]
  if currentLesson > 0 and card
    $(card).scrollintoview {
      duration: 2500,
      direction: "vertical"
    }

