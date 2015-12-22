
Template.layout.helpers
  lessonTitle: ()->
    return Scene.get().getCurrentLesson().title

  module: ()->
    return FlowRouter.getParam "_id"

Template.layout.events
  "click #open_side_panel": ()->
    console.log "CLICK"

  "click #logo": ()->
    Scene.get().goToLessonsPage()

