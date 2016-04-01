String::startsWith ?= (s) -> @[...s.length] is s
String::endsWith   ?= (s) -> s is '' or @[-s.length..] is s
String::orEmpty ?= (s) -> return s or= ""

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

Meteor.getContentSrc = ()->
  if Meteor.isCordova
    return 'http://127.0.0.1:8080/'
  if not Meteor.settings.public.CONTENT_SRC
    return "http://noorahealthcontent.noorahealth.org/"
  else
    return Meteor.settings.public.CONTENT_SRC

