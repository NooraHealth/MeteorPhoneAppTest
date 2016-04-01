
CurriculumSchema = require('../../../../api/curriculums/schema.coffee').CurriculumSchema

Template.Home_curriculum_menu_list_item.onCreated ->
  console.log "Home curriculum menu list item created:"
  # Data context validation
  console.log "Validating the list item data", Template.currentData()
  schema = new SimpleSchema({
    onCurriculumSelected: {type: Function}
  })

  callbackContext = schema.namedContext()
  callbackContext.validate(Template.currentData().onCurriculumSelected)
  if not callbackContext.isValid() then console.log "DATA CONTEXT ERROR: Home_curriculum_menu_list_item: callback data invalid"

  curriculumContext = CurriculumSchema.namedContext()
  curriculumContext.validate(Template.currentData().curriculum)
  console.log curriculumContext
  if not curriculumContext.isValid() then console.log "DATA CONTEXT ERROR: Home_curriculum_menu_list_item: curriculum data invalid"

Template.Home_curriculum_menu_list_item.events
  'click': ( e , template )->
    console.log "List item clicked"
    instance = Template.instance()
    data = Template.currentData()
    data.onCurriculmSelected data.curriculum._id
    #Scene.get().setCurriculum Curriculums.findOne {_id: data.curriculum._id}
    App.closePanel()

