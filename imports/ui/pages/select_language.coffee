
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
    FlowRouter.go "introduction"
    levels = AppState.get().getLevels()
    AppState.get().setLevel levels[0].name

Template.Select_language_page.helpers

  menuArgs: ->
    instance = Template.instance()
    return {
      onLanguageSelected: instance.onLanguageSelected
      languages: ['English', 'Hindi', 'Kannada']
    }
