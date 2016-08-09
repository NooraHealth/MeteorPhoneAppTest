
require './thumbnail.html'
require '../../../api/global_template_helpers.coffee'

Template.Select_level_thumbnail.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      "level.name": {type: String }
      "level.image": {type: String }
      isCurrentLevel: {type: Boolean}
      language: {type: String, defaultValue: "english"}
      onLevelSelected: {type: Function}
    }).validate(Template.currentData())

Template.Select_level_thumbnail.events
  'click' : ( e )->
    data = Template.currentData()
    data.onLevelSelected data.level.name

