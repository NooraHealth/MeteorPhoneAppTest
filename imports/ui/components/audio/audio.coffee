require './audio.html'

Template.Audio.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    whenFinished: null
  }

  @autorun =>
    new SimpleSchema({
      "attributes.src": {type: String}
      playing: {type: Boolean}
      whenFinished: {type: Function, optional: true}
    }).validate Template.currentData()

    @data = Template.currentData()

  @elem = (template) ->
    console.log @
    if not @state.get "rendered" then return ""
    else
      template.find "audio"

  @autorun =>
    console.log "Checking if the audio is playing"
    elemRendered = @state.get "rendered"
    if not elemRendered then return

    playing = Template.currentData().playing
    console.log "Should the audio be playing? ", playing
    instance = @
    elem = @elem instance
    if playing
      console.log "Playing the audio"
      console.log elem
      elem.currentTime = 0
      elem.play()
      elem.addEventListener "ended", @data.whenFinished
    else
      elem.pause()

Template.Audio.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true
