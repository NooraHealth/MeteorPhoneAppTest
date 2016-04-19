require './audio.html'

Template.Audio.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    whenFinished: null
  }

  @autorun =>
    console.log "Validating audio"
    console.log Template.currentData()
    new SimpleSchema({
      "attributes.src": {type: String}
      playing: {type: Boolean}
      whenFinished: {type: Function, optional: true}
      whenPaused: {type: Function, optional: true}
    }).validate Template.currentData()

    @data = Template.currentData()

  @elem = (template) ->
    if not @state.get "rendered" then return ""
    else
      template.find "audio"

  @autorun =>
    elemRendered = @state.get "rendered"
    if not elemRendered then return

    playing = Template.currentData().playing
    instance = @
    elem = @elem instance
    if playing
      console.log "playing this", elem
      elem.currentTime = 0
      elem.play()
      elem.addEventListener "ended", => @data.whenFinished?()
      elem.addEventListener "pause", => @data.whenPaused?()
    else
      elem.pause()

Template.Audio.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true
