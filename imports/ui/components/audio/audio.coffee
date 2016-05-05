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
    console.log "IN AUDIO AUTORUN"
    data = Template.currentData()
    shouldPlay = data.playing
    alreadyPlaying = @state.get "playing"
    if shouldPlay and not alreadyPlaying
      console.log "PLAYING"
      console.log "PLaying ", data.attributes.src
      @sound = new Howl {
        urls: [data.attributes.src]
        onloaderror: ->
          console.log "LOADERROR #{data.attributes.src}"
          console.trace()
        onend: @data.whenFinished
        onpause: @data.whenPaused
      }
      @sound.play()
      @state.set "playing", true
    else if not shouldPlay and alreadyPlaying and @sound?
      @state.set "playing", false
      @sound.pause()

Template.Audio.onDestroyed ->
  instance = Template.instance()
  isPlaying = instance.state.get "playing"
  if isPlaying
    instance.sound?.pause()
  instance.sound?.unload()
