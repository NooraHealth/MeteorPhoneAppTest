
{ ContentInterface } = require '../content/ContentInterface.coffee'

{ Translator } = require './../utilities/Translator.coffee'

Template.registerHelper 'translate', ( key, language, textCase )=>
  return Translator.translate key, language, textCase

Template.registerHelper 'getSrc', ( filename, type )=>
  if filename? and filename != ""
    ContentInterface.getSrc filename, type
  else return ""
