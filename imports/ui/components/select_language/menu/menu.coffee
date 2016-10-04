
require './list_item.coffee'
require './menu.html'

Template.Home_language_menu.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      languages: {type: [String]}
      onRendered: {type: Function, optional: true}
    }).validate(Template.currentData())

Template.Home_language_menu.helpers
  listItemArgs: (language) ->
    instance = Template.instance()
    onLanguageSelected = Template.currentData().onLanguageSelected
    return {
      language: language
      onLanguageSelected: onLanguageSelected
    }
    
  languages: ()->
    return Template.currentData().languages

Template.Home_language_menu.onRendered ->
  Template.currentData().onRendered?()


