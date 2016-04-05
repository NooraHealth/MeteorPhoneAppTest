
require './go_home_btn.html'

Template.Lesson_view_page_go_home_btn.events
  "click": ()->
    FlowRouter.go "/"
