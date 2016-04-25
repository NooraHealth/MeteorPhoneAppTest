
require './layout.html'
AppState = require('../../api/AppState.coffee').AppState

Template.Layout.onCreated ->
  console.log "IN THE ON CREATED"
  @autorun =>
    console.log "in the layout autorun"
    error = AppState.get().getError()
    console.log "this is the message"
    console.log error
    if error
      AppState.get().setError null
      swal {
        type: "error"
        title: error.error
        text: error.reason
      }

