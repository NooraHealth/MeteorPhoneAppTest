
Template.Home_curriculum_menu_list_item.onCreated ->
  console.log "Home curriculum menu list item created:"
  # Data context validation
  @autorun =>
    console.log "Validating the list item data", Template.currentData()

    schema = new SimpleSchema({
      onCurriculumSelected: {type: Function}
      title: {type: String}
      _id: {type: String}
    })

    callbackContext = schema.namedContext()
    callbackContext.validate(Template.currentData())
    if not callbackContext.isValid() then console.log "DATA CONTEXT ERROR: Home_curriculum_menu_list_item: callback data invalid"

Template.Home_curriculum_menu_list_item.events
  'click': ( e , template )->
    console.log "List item clicked"
    instance = Template.instance()
    data = Template.currentData()
    data.onCurriculmSelected data.curriculum._id
    #Scene.get().setCurriculum Curriculums.findOne {_id: data.curriculum._id}
    App.closePanel()

