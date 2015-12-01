Template.lessonsView.helpers
  lessons: ()->
    currId = FlowRouter.getParam "curr_id"
    curriculum = Curriculum.findOne {_id: currId } || {}
    return curriculum

Template.lessonsView.onCreated ()->
  @.autorun ()=>
    curriculumId = FlowRouter.getParam "curr_id"
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

