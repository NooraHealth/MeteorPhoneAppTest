require './thumbnail.html'

Template.Home_thumbnail.onCreated ->
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


Template.Home_thumbnail.events
  'click' : ( e )->
    Scene.get().goToModules( Template.currentData()._id )

  
