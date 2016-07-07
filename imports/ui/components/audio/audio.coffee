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
        onend: @data.whenFinished
        onpause: @data.whenPaused
        #html5: true
      }
      @sound.play()
      #@sound.mute(false)
    else if not shouldPlay and @sound?
      @sound.pause()

Template.Audio.onDestroyed ->
  instance = Template.instance()
  if instance.sound? and instance.sound.playing()
    instance.sound.pause()
  #instance.sound?.unload()
