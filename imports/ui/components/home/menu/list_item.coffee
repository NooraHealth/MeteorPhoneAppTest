
require './list_item.html'

Template.Home_language_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    console.log "validating the list item"
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      language: {type: String}
    }).validate(Template.currentData())
    console.log "validated"

Template.Home_language_menu_list_item.events
  'click': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    data.onLanguageSelected data.language
    App.closePanel("right")

