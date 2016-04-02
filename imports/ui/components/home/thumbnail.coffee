
Lessons = require('../../../api/lessons/lessons.coffee').Lessons
require './thumbnail.html'

Template.Home_thumbnail.onCreated ->
  # Data context validation
  @autorun =>
    console.log "This is the lesson doc", Template.currentData().lesson
    console.log Lessons
    schema = new SimpleSchema({
      lesson: {type: Lessons._helpers}
      isCurrentLesson: {type: Boolean}
      onLessonSelected: {type: Function}
    }).validate(Template.currentData())

    #callbackContext = schema.namedContext()
    #callbackContext.validate(Template.currentData())
    #if not callbackContext.isValid() then console.log "DATA CONTEXT ERROR: Home_curriculum_menu_list_item: callback data invalid"


Template.Home_thumbnail.events
  'click' : ( e )->
    data = Template.currentData()
    data.onLessonSelected data.lesson._id


  
