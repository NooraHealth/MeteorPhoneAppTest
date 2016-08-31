

{ AppState } = require '../../../../api/AppState.coffee'
require '../../../../api/utilities/global_template_helpers.coffee'
require './list_item.html'

Template.Home_language_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      language: {type: String}
    }).validate(Template.currentData())

  @onClick = (e, data)=>
    data.onLanguageSelected data.language

Template.Home_language_menu_list_item.events
  'touchend': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    instance.onClick e, data

  'click': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    instance.onClick e, data

