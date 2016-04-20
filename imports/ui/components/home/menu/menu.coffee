
require './menu.html'

Template.Home_curriculum_menu.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onCurriculumSelected: {type: Function}
      curriculums: {type: Mongo.Cursor}
    }).validate(Template.currentData())

Template.Home_curriculum_menu.helpers
  listItemArgs: (curriculum) ->
    instance = Template.instance()
    onCurriculumSelected = Template.currentData().onCurriculumSelected
    return {
      curriculum: curriculum
      onCurriculumSelected: onCurriculumSelected
    }
    
  curriculums: ()->
    return Template.currentData().curriculums

