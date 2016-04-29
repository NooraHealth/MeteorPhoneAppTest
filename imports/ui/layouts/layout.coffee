
{ AppState } = require('../../api/AppState.coffee').AppState
require './layout.html'

Template.Layout.onCreated ->
  @autorun =>
    error = AppState.get().getError()
    if error
      AppState.get().setError null
      swal {
        type: "error"
        title: error.error
        text: error.reason
      }

