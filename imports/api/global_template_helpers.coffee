
{ ContentInterface } = require './content/ContentInterface.coffee'
{ AppState } = require './AppState.coffee'

#Template.registerHelper 'getSrc', ( path, type )->
  #console.log "Getting the src #{path} #{type}"
  #return ContentInterface.get().getSrc path, type

Template.registerHelper 'translate', ( key, language )=>
  AppState.translate key, language

Template.registerHelper 'getSrc', ( filename, type )=>
  if filename? and filename != ""
    ContentInterface.getSrc filename, type
  else return ""
