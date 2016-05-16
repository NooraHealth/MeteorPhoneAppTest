
{ AppState } = require '../../api/AppState.coffee'
require './wrapper_page.html'

Template.Wrapper_page.helpers
  home: ->
    console.log "Getting the route"
    return AppState.get().route() == "Home_page"
