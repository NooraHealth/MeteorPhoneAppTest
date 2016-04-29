
{ ContentInterface } = require './ContentInterface.coffee'

Template.registerHelper 'getSrc', (path)->
  return ContentInterface.get().getSrc path
