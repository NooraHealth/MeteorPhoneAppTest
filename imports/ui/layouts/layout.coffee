
{ AppState } = require('../../api/AppState.coffee')
require './layout.html'

Template.Layout.onCreated ->
  @autorun =>
    error = AppState.getError()
    if error
      AppState.setError null
      swal {
        type: "error"
        title: error.error
        text: error.reason
      }

