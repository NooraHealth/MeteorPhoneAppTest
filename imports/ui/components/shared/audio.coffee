
{ AudioContent } = require '../../../api/content/AudioContent.coffee'

class Audio
  constructor: (@filename, @volume)->
    new SimpleSchema({
      filename: {type: String}
      volume: {type: Number, optional: true}
    }).validate {filename: @filename, volume: @volume}

  onEnd: (whenFinished) =>
    whenFinished?( @sound.pos?(), true, @filename )

  onPause: (whenPaused) =>
    whenPaused?( @sound.pos?(), false, @filename )
  
  onLoadError: (whenFinished, id, error) =>
    whenFinished?( @sound.pos?(), false, @filename )

  replay: (afterReplay) =>
    @stop()
    @play()
    afterReplay?()

  pause: =>
    @sound?.pause()

  stop: =>
    @sound?.stop()

  destroy: =>
    @sound?.unload()

  play: ( whenFinished, whenPaused )=>
    alreadyPlaying = @sound?.playing()
    if not alreadyPlaying
      volume = if @volume? then @volume else 1
      src = AudioContent.getSrc @filename
      @sound ?= new Howl {
        src: [src]
        onloaderror: @onLoadError.bind(@, whenFinished)
        #onplay: -> console.log "Playing the audio"
        onend: @onEnd.bind(@, whenFinished)
        onpause: @onPause.bind(@, whenPaused)
        volume: volume
      }
      @sound.play()

module.exports.Audio = Audio
