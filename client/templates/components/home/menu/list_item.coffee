
Template.Home_curriculum_menu_list_item.events
  'click': ( e , template )->
    console.log "List item clicked"
    instance = Template.instance()
    data = Template.currentData()
    data.onCurriculmSelected data.curriculum._id
    #Scene.get().setCurriculum Curriculums.findOne {_id: data.curriculum._id}
    App.closePanel()

Template.Home_curriculum_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    console.log "Validating the context"
    console.log Template.currentData()
    schema = new SimpleSchema({
      title: {type: String}
      id: {type: String}
      onCurriculmSelected: {type: Function}
    })

    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu_list_item"


