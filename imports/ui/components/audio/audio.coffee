require './audio.html'

Template.Audio.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    whenFinished: null
  }

  @autorun =>
    schema = new SimpleSchema {
      "attributes.src": {type: String}
      playing: {type: Boolean}
      whenFinished: {type: Function, optional: true}
    }

    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu"

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
    if playing
      console.log "This is the elem", @elem instance
      @elem(instance).currentTime = 0
      @elem(instance).play()
    else
      @elem(instance).pause()

Template.Audio.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true
