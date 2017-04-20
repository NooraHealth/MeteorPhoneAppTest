
{ AudioContent } = require '../../../api/content/AudioContent.coffee'

class Audio
  constructor: (@filename, @volume, @whenFinished, @whenPaused, @onLoadError)->
    new SimpleSchema({
      filename: {type: String}
      volume: {type: Number, optional: true}
    }).validate {filename: @filename, volume: @volume}

  onEnd: =>
    @whenFinished?( true, @filename, @sound.duration() )

  onPause: =>
    @whenPaused?( false, @filename, @sound.duration() )

  onLoadError: ( whenFinished, id, error )=>
    @onLoadError?( @filename, @sound.duration() )

  replay: ( afterReplay )=>
    @stop()
    @play()
    afterReplay?()

  pause: =>
    console.log "Pausing the audio"
    @sound?.pause()

  stop: =>
    console.log "Stopping the audio"
    @sound?.stop()

  destroy: =>
    console.log "DESTROYING"
    console.log @
    @pause()
    @sound?.unload()

  play: =>
    alreadyPlaying = @sound?.playing()
    if not alreadyPlaying
      volume = if @volume? then @volume else 1
      src = AudioContent.getSrc @filename
      @sound ?= new Howl {
        src: [src]
        onloaderror: @onLoadError.bind(@)
        #onplay: -> console.log "Playing the audio"
        onend: @onEnd.bind(@)
        onpause: @onPause.bind(@)
        volume: volume
      }
      @sound.play()

module.exports.Audio = Audio
