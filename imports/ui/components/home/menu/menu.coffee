
require './menu.html'

Template.Home_curriculum_menu.onCreated ->
  console.log "validating emnu"
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
    console.log "The curriculums to get the args"
    console.log curriculum
    return {
      curriculum: curriculum
      onCurriculumSelected: onCurriculumSelected
    }
    
  curriculums: ()->
    return Template.currentData().curriculums

