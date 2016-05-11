
require './menu.html'

Template.Home_language_menu.onCreated ->
  # Data context validation
  @autorun =>
    console.log "Validating the home menu"
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      languages: {type: [String]}
    }).validate(Template.currentData())
    console.log "validated"

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

