
{ ContentInterface } = require './content/ContentInterface.coffee'
{ AppState } = require './AppState.coffee'

#Template.registerHelper 'getSrc', ( path, type )->
  #console.log "Getting the src #{path} #{type}"
  #return ContentInterface.get().getSrc path, type

Template.registerHelper 'translate', ( key, language )=>
  console.log "Getting the translation"
  tag = AppState.getLangTag language
  return TAPi18n.__ key, {}, tag


Template.registerHelper 'getSrc', ( filename, type )=>
  console.log "getting the src of #{filename}"
  if filename? and filename != ""
    ContentInterface.getSrc filename, type
  else return ""
