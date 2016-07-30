
{ AppState } = require '../../../../api/AppState.coffee'
require '../../../../api/global_template_helpers.coffee'
require './list_item.html'

Template.Home_language_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      language: {type: String}
    }).validate(Template.currentData())

#Template.Home_language_menu_list_item.helpers
  #translate: ( text, language )->
    #console.log "The language tag"
    #console.log language
    #console.log AppState.getLangTag language
    #tag = AppState.getLangTag language
    #return TAPi18n.__ "name", {}, tag

Template.Home_language_menu_list_item.events
  'touchend': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    data.onLanguageSelected data.language

