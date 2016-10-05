##############################################################################
#
# AudioContent
# 
# The interface between the audio on the remote server and the app
#
##############################################################################

{ OfflineFiles } = require "../collections/offline_files.js"
{ ContentInterface } = require "./base/ContentInterface.coffee"

cloudinary = require("cloudinary")

class AudioContent extends ContentInterface

  constructor: ->
    super()
    @_directory = "Audio/"
    
  getRemoteContent: ( filename )->
    new SimpleSchema({
      filename: { type: String }
    }).validate({ filename: filename })
  
    path = @getFullPath filename
    return cloudinary.url path, { resource_type: "video", transformation: ["mobile_audio"] }

class SingletonWrapper
  @getAudioContent: ->
    @audioContent ?= new AudioContent()
    return @audioContent

module.exports.AudioContent = SingletonWrapper.getAudioContent()

module.exports.correctSoundEffectFilename = "correct_soundeffect.mp3"

module.exports.incorrectSoundEffectFilename = "incorrect_soundeffect.mp3"

