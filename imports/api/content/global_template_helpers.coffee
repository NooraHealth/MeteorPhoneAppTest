
{ ContentInterface } = require './ContentInterface.coffee'

Template.registerHelper 'getSrc', ( path, type )->
  console.log "Getting the src #{path}"
  return ContentInterface.get().getSrc path, type
