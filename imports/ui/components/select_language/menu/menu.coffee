
require './list_item.coffee'
require './menu.html'

Template.Language_menu.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      languages: {type: [String]}
    }).validate(Template.currentData())

Template.Language_menu.helpers
  listItemArgs: (language) ->
    instance = Template.instance()
    onLanguageSelected = Template.currentData().onLanguageSelected
    return {
      language: language
      onLanguageSelected: onLanguageSelected
    }
    
  languages: ()->
    return Template.currentData().languages


