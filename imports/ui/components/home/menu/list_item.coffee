require './list_item.html'

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
    console.log Template.currentData()
    console.log Document
    console.log Mongo.Document
    schema = new SimpleSchema({
      curriculum: {type: CurriculumSchema}
      onCurriculumSelected: {type: Function}
    })

    context = schema.namedContext()
    response = context.validate(Template.currentData())
    console.log response
    console.log context

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu_list_item", Template.currentData()


