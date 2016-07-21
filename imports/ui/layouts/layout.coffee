
{ AppState } = require('../../api/AppState.coffee')
require './layout.html'

Template.Layout.onCreated ->
  console.log "Rendering the layout"
  @autorun =>
    error = AppState.get().getError()
    if error
      AppState.get().setError null
      swal {
        type: "error"
        title: error.error
        text: error.reason
      }

