
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
require './thumbnail.html'
require '../../../api/global_template_helpers.coffee'

Template.Home_thumbnail.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      "level.name": {type: String }
      "level.image": {type: String }
      isCurrentLevel: {type: Boolean}
      onLevelSelected: {type: Function}
    }).validate(Template.currentData())

Template.Home_thumbnail.events
  'click' : ( e )->
    data = Template.currentData()
    data.onLevelSelected data.level.name

Template.Home_thumbnail.onRendered ->
  if Template.currentData().isCurrentLesson
    Template.instance().$(".js-scroll-into-view").scrollintoview {
      duration: 2500,
      direction: "vertical"
    }
    

  
