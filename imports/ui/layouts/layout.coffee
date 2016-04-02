require '../layouts/Content_wrapper.html'
require '../layouts/layout.html'

Template.layout.helpers
  lessonTitle: ()->
    return Scene.get().getCurrentLesson().title

  module: ()->
    console.log "Returning thwther there is a module"
    console.log FlowRouter.getParam "_id"
    return FlowRouter.getParam "_id"

Template.layout.events
  "click #open_side_panel": ()->
    console.log "CLICK"

  "click #logo": ()->
    Scene.get().goToLessonsPage()

