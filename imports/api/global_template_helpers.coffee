
{ ContentInterface } = require './content/ContentInterface.coffee'
{ AppState } = require './AppState.coffee'

#Template.registerHelper 'getSrc', ( path, type )->
  #console.log "Getting the src #{path} #{type}"
  #return ContentInterface.get().getSrc path, type

Template.registerHelper 'translate', ( key, language, textCase )=>
  return AppState.translate key, language, textCase

Template.registerHelper 'getSrc', ( filename, type )=>
  if filename? and filename != ""
    ContentInterface.getSrc filename, type
  else return ""
