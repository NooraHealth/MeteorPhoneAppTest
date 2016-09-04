
class Audio
  constructor: (@src, @volume)->
    new SimpleSchema({
      src: {type: String}
      volume: {type: Number, optional: true}
    }).validate {src: @src, volume: @volume}

  onEnd: (whenFinished) =>
    whenFinished?( @sound.pos?(), true, @src )

  onPause: (whenPaused) =>
    whenPaused?( @sound.pos?(), false, @src )
  
  onLoadError: (whenFinished, id, error) =>
    whenFinished?( @sound.pos?(), false, @src )

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
      @sound ?= new Howl {
        src: [@src]
        onloaderror: @onLoadError.bind(@, whenFinished)
        #onplay: -> console.log "Playing the audio"
        onend: @onEnd.bind(@, whenFinished)
        onpause: @onPause.bind(@, whenPaused)
        volume: volume
      }
      @sound.play()

module.exports.Audio = Audio
