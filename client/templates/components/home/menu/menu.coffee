Template.Home_curriculum_menu.helpers
  curriculums: ()->
    return Curriculums.find({title:{$ne: "Start a New Curriculum"}})

Template.Home_curriculum_menu.onCreated ->
  @autorun =>
    console.log Template.currentData()
    schema = new SimpleSchema({
      onCurriculmSelected: {type: Function}
    })

    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu"


