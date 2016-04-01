Template.Audio.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    readyToPlay: false
    playWhenReady: false
    whenFinished: null
    playing: false
  }

  @autorun =>
    schema = new SimpleSchema {
      src: {type: String}
      id: {type: String}
    }

    context = schema.namedContext()
    context.validate(Template.currentData())

    if not context.isValid() then console.log "ERROR: data context invalude for Home_curriculum_menu"

Template.Audio.helpers {
  arguments: ->
    data = Template.currentData()
    return "src=#{data.src} id=#{data.id}"
}
