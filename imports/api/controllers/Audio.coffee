
{ Audio } = require('../../ui/components/shared/audio.coffee')
{ Analytics } = require '../../api/analytics/Analytics.coffee'

class AudioController
  constructor: ->
    @liveAudio = []

    @setCurrentAudio = (audio) ->
      @currentAudio = audio
      @

    @getCurrentAudio = ->
      return @currentAudio

  stopAudio: ->
    console.log "STOPPING THE AUDIO"
    console.log @getCurrentAudio()
    @getCurrentAudio().stop()

  replayCurrentAudio: ->
    @getCurrentAudio().replay()

  destroyAudio: ->
    for audio in @liveAudio
      audio.destroy()
    @liveAudio = []

  playAudio: ( filename, volume, isSoundEffect, whenFinished, whenPaused )->
    audio = new Audio filename, volume
    audio.play whenFinished, whenPaused
    @liveAudio.push audio
    if not isSoundEffect
      @setCurrentAudio audio
    return audio

  trackAudioStopped: ( module, lesson, pos, completed, filename ) ->
    text = if module?.title then module?.title else module?.question
    Analytics.registerEvent "TRACK", "Audio Stopped", {
      moduleText: text
      filename: filename
      moduleId: module?._id
      language: @language
      condition: @condition
      time: pos
      completed: completed
      lessonTitle: lesson?.title
      lessonId: lesson?._id
    }
    @


module.exports.AudioController = AudioController
