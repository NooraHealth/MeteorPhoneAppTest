
require './list_item.html'

Template.Home_language_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    console.log 'validating the list time'
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      language: {type: String}
    }).validate(Template.currentData())
    console.log "Validated"

Template.Home_language_menu_list_item.events
  'touchend': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    data.onLanguageSelected data.language

