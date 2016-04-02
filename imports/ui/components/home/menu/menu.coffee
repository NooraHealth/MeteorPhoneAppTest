
require './menu.html'

Template.Home_curriculum_menu.onCreated ->
  @autorun =>
    schema = new SimpleSchema({
      onCurriculumSelected: {type: Function}
      curriculums: {type: Mongo.Cursor}
    })

    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu"


Template.Home_curriculum_menu.helpers
  listItemArgs: (curriculum) ->
    instance = Template.instance()
    onCurriculumSelected = Template.currentData().onCurriculumSelected
    return {
      #curriculum: curriculum
      title: curriculum.title
      _id: curriculum._id
      onCurriculumSelected: onCurriculumSelected
    }
    
  curriculums: ()->
    return Template.currentData().curriculums

