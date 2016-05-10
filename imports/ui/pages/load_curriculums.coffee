require './load_curriculums.html'

{ AppState } = require '../../api/AppState.coffee'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'

Template.Load_curriculums_page.onCreated ->
  configuration = AppState.get().getConfiguration()
  curriculums = Curriculums.find { condition: configuration.condition }
  console.log "Going to load these curriculums"
  console.log curriculums
  
