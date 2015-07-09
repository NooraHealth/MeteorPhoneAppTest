class @Base
  keywords = ['extended', 'included']

  #static properties of the class
  extend: (obj) ->
    for key, value of obj when key not in keywords
      @[key] = value
    obj.extended?.apply @

  #Instance properties added to the prototype
  include: (obj)->
    for key, value of obj when key not in keywords
      @::[key] = value
    obj.included?.apply @

Meteor.filePrefix = (file)->
  #Store file into a directory by the user's username.
  if not file?
    return ""
  if file.type.match /// video/ ///
    prefix = CONTENT_FOLDER + VIDEO_FOLDER
  if file.type.match /// audio/ ///
    prefix = CONTENT_FOLDER + AUDIO_FOLDER
  if file.type.match /// image/ ///
    prefix = CONTENT_FOLDER + IMAGE_FOLDER

  return prefix + file.name
