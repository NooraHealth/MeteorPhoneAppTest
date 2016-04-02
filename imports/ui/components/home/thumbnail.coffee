
Lessons = require('../../../api/lessons/lessons.coffee').Lessons
require './thumbnail.html'

Template.Home_thumbnail.onCreated ->
  # Data context validation
  @autorun =>

    console.log "This is the lesson doc", Template.currentData().lesson
    console.log Lessons
    schema = new SimpleSchema({
      isCurrentLesson: {type: Boolean}
      lesson: {type: Lessons._helpers}
      _id: {type: String}
    }).validate(Template.currentData())

    #callbackContext = schema.namedContext()
    #callbackContext.validate(Template.currentData())
    #if not callbackContext.isValid() then console.log "DATA CONTEXT ERROR: Home_curriculum_menu_list_item: callback data invalid"


Template.Home_thumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
