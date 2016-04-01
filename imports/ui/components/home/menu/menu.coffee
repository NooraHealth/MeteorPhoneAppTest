
Template.Home_curriculum_menu.onCreated ->
  @autorun =>
    console.log "Validating the MENU"
    console.log "Context: "
    console.log Template.currentData()

    schema = new SimpleSchema({
      onCurriculumSelected: {type: Function}
      curriculums: {type: Mongo.Cursor}
    })

    console.log Template.currentData().curriculums.fetch()
    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu"


Template.Home_curriculum_menu.helpers
  listItemArgs: (curriculum) ->
    console.log "Getting the listItem args", curriculum
    instance = Template.instance()
    console.log instance
    onCurriculumSelected = Template.currentData().onCurriculumSelected
    console.log onCurriculumSelected
    return {
      curriculum: curriculum
      onCurriculumSelected: onCurriculumSelected
    }
    
  curriculums: ()->
    return Template.currentData().curriculums

