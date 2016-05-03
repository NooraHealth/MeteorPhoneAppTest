
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
require './list_item.html'

Template.Home_curriculum_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onCurriculumSelected: {type: Function}
      curriculum: {type: Curriculums._helpers}
    }).validate(Template.currentData())

Template.Home_curriculum_menu_list_item.events
  'click': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    data.onCurriculumSelected data.curriculum._id
    App.closePanel("right")

