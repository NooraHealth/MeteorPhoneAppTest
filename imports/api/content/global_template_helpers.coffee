
{ ContentInterface } = require './ContentInterface.coffee'

Template.registerHelper 'getSrc', (path)->
  console.log "Getting the src #{path}"
  return ContentInterface.get().getSrc path
