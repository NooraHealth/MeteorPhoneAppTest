
{ AudioContent } = require '../content/AudioContent.coffee'
{ ImageContent } = require '../content/ImageContent.coffee'
{ VideoContent } = require '../content/VideoContent.coffee'
{ Translator } = require './../utilities/Translator.coffee'

Template.registerHelper 'translate', ( key, language, textCase )=>
  return Translator.translate key, language, textCase

Template.registerHelper 'getSrc', ( filename, type )=>
  if filename? and filename != ""
    switch type
      when "AUDIO" then AudioContent.getSrc filename
      when "IMAGE" then ImageContent.getSrc filename
      when "VIDEO" then VideoContent.getSrc filename
      else throw new Meteor.Error "retrieving_src", "file type must be provided"
       
