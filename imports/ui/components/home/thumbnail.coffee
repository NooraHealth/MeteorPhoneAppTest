
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
require '../../../api/content/global_template_helpers.coffee'
require './thumbnail.html'

Template.Home_thumbnail.onCreated ->
  # Data context validation
  console.log "Home thumbnail created"
  @autorun =>
    console.log "Validating the thumbnail"
    schema = new SimpleSchema({
      lesson: {type: Lessons._helpers}
      isCurrentLesson: {type: Boolean}
      onLessonSelected: {type: Function}
    }).validate(Template.currentData())

Template.Home_thumbnail.events
  'click' : ( e )->
    data = Template.currentData()
    data.onLessonSelected data.lesson._id

Template.Home_thumbnail.onRendered ->
  if Template.currentData().isCurrentLesson
    Template.instance().$(".js-scroll-into-view").scrollintoview {
      duration: 2500,
      direction: "vertical"
    }
    


  
