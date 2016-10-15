
{ Modules } = require "../../../../api/collections/schemas/curriculums/lessons.js"
require './thumbnail.html'
require '../../../../api/utilities/global_template_helpers.coffee'

Template.Level_thumbnail.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      "level.index": {type: Number }
      "level.image": {type: String }
      "level.name": {type: String }
      isCurrentLevel: {type: Boolean}
      language: {type: String, defaultValue: "english"}
      onLevelSelected: {type: Function}
    }).validate(Template.currentData())

Template.Level_thumbnail.events
  'click' : ( e )->
    data = Template.currentData()
    data.onLevelSelected data.level.index

Template.Level_thumbnail.onRendered ->
  if Template.currentData().isCurrentLesson
    Template.instance().$(".js-scroll-into-view").scrollintoview {
      duration: 2500,
      direction: "vertical"
    }
