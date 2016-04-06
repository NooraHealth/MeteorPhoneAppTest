
VIDEO_FOLDER = "Video/"
IMAGE_FOLDER = "Image/"
AUDIO_FOLDER = "Audio/"

class ContentInterface
  @get: ()->
    if !@interface
      @interface = new PrivateInterface()
    return @interface
  
  class PrivateInterface

    getUrl: (path) => @_getContentSrc + path

    _getContentSrc: ->
      if Meteor.isCordova
        'http://127.0.0.1:8080/'
      else
        Meteor.settings.public.CONTENT_SRC

    _filePrefix: ->
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

module.exports.ContentInterface = ContentInterface
