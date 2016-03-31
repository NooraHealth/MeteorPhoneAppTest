Template.Home_curriculum_menu.helpers
  listItemArgs: (curriculum) ->
    instance = Template.instance()
    console.log instance
    data = Template.currentData()
    return {
      curriculum: curriculum
      onCurriculumSelected: data.onCurriculumSelected
    }
    
  curriculums: ()->

Template.Home_curriculum_menu.onCreated ->
  @autorun =>
    console.log "Context: "
    console.log Template.currentData()
    schema = new SimpleSchema({
      onCurriculumSelected: {type: Function}
      curriculums: {type: Mongo.Cursor}
    })

    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu"


