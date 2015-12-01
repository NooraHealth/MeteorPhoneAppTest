Template.lessonsView.helpers
  lessons: ()->
    currId = FlowRouter.getParam "curr_id"
    curriculum = Curriculum.findOne {_id: currId }
    console.log "Here is the currId", currId
    console.log "Here is the curriculum", curriculum
    if curriculum
      return curriculum.getLessonDocuments()
    else
      return []

Template.lessonsView.onCreated ()->
  console.log "On Created!"
  @.autorun ()=>
    console.log "Subscribing"
    curriculumId = FlowRouter.getParam "curr_id"
    @.subscribe "curriculums"
    @.subscribe "lessons", curriculumId
    
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

