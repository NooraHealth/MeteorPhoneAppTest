require './audio.html'

Template.Audio.onCreated ->

  @state = new ReactiveDict()
  @state.setDefault {
    playing: false
  }

  @autorun =>
    data = Template.currentData()
    new SimpleSchema({
      "attributes.src": {type: String}
      playing: {type: Boolean}
      whenFinished: {type: Function, optional: true}
      whenPaused: {type: Function, optional: true}
    }).validate data

    @sound = new Howl {
      urls: [data.attributes.src]
      onend: data.whenFinished
      #onpause: data.whenPaused
      onend: ->
        console.log "ON END"
      onpause: ->
        console.log "ON PAUSE"
      onloaderror: (error)->
        console.log "error loading #{data.attributes.src}"
        console.log error
      onplay: =>
        console.log "I am being played!", data.attributes.src
    }

  @autorun =>
    shouldPlay = Template.currentData().playing
    console.log "Change to teh state of #{Template.currentData().attributes.src} #{shouldPlay}"
    alreadyPlaying = @state.get "playing"
    if shouldPlay and not alreadyPlaying
      console.log "playing the sound"
      console.log @sound
      @state.set "playing", true
      @sound.play()
    else if alreadyPlaying
      @sound.stop()

Template.Audio.onDestroyed ->
  console.log "Destroying #{Template.instance().sound}"
  if Template.instance().sound?
    console.log "stopping thehowl"
    console.log Template.instance().sound
    Template.instance().sound.stop()
      
