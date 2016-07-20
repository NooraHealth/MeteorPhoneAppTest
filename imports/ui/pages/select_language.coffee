
{ AppState } = require('../../api/AppState.coffee')

# TEMPLATE
require './select_language.html'

# COMPONENTS
require '../../ui/components/shared/navbar.html'
require '../../ui/components/home/menu/menu.coffee'

Template.Select_language_page.onCreated ->
  console.log "Select language page created"

  @onLanguageSelected = (language) ->
    analytics.track "Changed Language", {
      fromLanguage: AppState.get().getLanguage()
      toLanguage: language
      condition: AppState.get().getCondition()
    }

    AppState.get().setLanguage language
    AppState.get().setLessonIndex 0
    FlowRouter.go "lessons"

Template.Select_language_page.helpers

  menuArgs: ->
    instance = Template.instance()
    return {
      onLanguageSelected: instance.onLanguageSelected
      languages: ['English', 'Hindi', 'Kannada']
    }
