require './audio.html'

Template.Audio.onCreated ->
  @autorun =>
    @data = Template.currentData()
    new SimpleSchema({
      "attributes.src": {type: String}
      playing: {type: Boolean}
      replay: {type: Boolean, optional: true}
      afterReplay: {type: Function, optional: true}
      whenFinished: {type: Function, optional: true}
      whenPaused: {type: Function, optional: true}
    }).validate @data

  @onEnd = =>
    @data.whenFinished( @sound.pos(), true, @data.attributes.src )

  @onPause = =>
    @data.whenPaused( @sound.pos(), false, @data.attributes.src )

  @autorun =>
    data = Template.currentData()
    shouldReplay = data.replay
    if shouldReplay
      @sound?.stop()
      @sound?.play()
      data.afterReplay()

  @autorun =>
    data = Template.currentData()
    shouldPlay = data.playing
    alreadyPlaying = @sound?.playing()
    if shouldPlay and not alreadyPlaying
      #@sound = new Media(data.attributes.src)
      @sound ?= new Howl {
        src: [data.attributes.src]
        onloaderror: (id, error)->
          console.log "LOADERROR #{data.attributes.src}"
          console.log error
          console.trace()
        onend: @data.whenFinished
        onpause: @data.whenPaused
        onplay: ()->
          console.log "begun playing #{data.attributes.src}"
          console.log @
        #html5: true
      }
      @sound.play()
      #@sound.mute(false)
    else if not shouldPlay and @sound?
      @sound.pause()

Template.Audio.onDestroyed ->
  instance = Template.instance()
  if instance.sound? and instance.sound.playing()
    console.log "pausing the sound"
    instance.sound.pause()
  #instance.sound?.unload()
