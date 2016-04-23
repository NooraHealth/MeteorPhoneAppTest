require './audio.html'

Template.Audio.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    playing: false
  }

  @autorun =>
    @data = Template.currentData()
    new SimpleSchema({
      "attributes.src": {type: String}
      playing: {type: Boolean}
      whenFinished: {type: Function, optional: true}
      whenPaused: {type: Function, optional: true}
    }).validate @data

  @autorun =>
    data = Template.currentData()
    shouldPlay = data.playing
    alreadyPlaying = @state.get "playing"
    if shouldPlay and not alreadyPlaying
      console.log "Autorun playing!!! #{data.attributes.src}"
      @sound = new Howl {
        urls: [data.attributes.src]
        onloaderror: ->
          console.log "LOADERROR #{data.attributes.src}"
        onend: @data.whenFinished
        onpause: @data.whenPaused
        #onpause: ->
          #console.log "PAUSED #{data.attributes.src}"
        #onload: ->
          #console.log "LOADED #{data.attributes.src}"
        #onplay: ->
          #console.log "PLAY #{data.attributes.src}"
        #onend: ->
          #console.log "ENDED #{data.attributes.src}"
      }
      @sound.play()
      @state.set "playing", true
    else if not shouldPlay and alreadyPlaying and @sound?
      console.log "Stopping the audio"
      @state.set "playing", false
      @sound.pause()

Template.Audio.onDestroyed ->
  instance = Template.instance()
  isPlaying = instance.state.get "playing"
  console.log "Is it playing?", isPlaying
  if isPlaying
    console.log "Is playing!"
    console.log instance.sound
    instance.sound?.stop()
  instance.sound?.unload()
