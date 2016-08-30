
class Audio
  constructor: (@src, @volume)->
    console.log "Making a new audio"
    console.log @src
    console.log @volume
    new SimpleSchema({
      src: {type: String}
      volume: {type: Number, optional: true}
    }).validate {src: @src, volume: @volume}

  onEnd: (whenFinished) =>
    whenFinished?( @sound.pos?(), true, @src )

  onPause: (whenPaused) =>
    whenPaused?( @sound.pos?(), false, @src )
  
  onLoadError: (whenFinished, id, error) =>
    console.log "Id"
    console.log id
    console.log "Error"
    console.log error
    console.log "LoadError"
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
    console.log "Playing this audio #{@src}"
    console.log @src
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
