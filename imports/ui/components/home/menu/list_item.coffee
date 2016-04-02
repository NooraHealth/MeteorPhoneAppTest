
require './list_item.html'

Template.Home_curriculum_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>

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
    instance = Template.instance()
    data = Template.currentData()
    data.onCurriculumSelected data._id
    #Scene.get().setCurriculum Curriculums.findOne {_id: data.curriculum._id}
    App.closePanel()

