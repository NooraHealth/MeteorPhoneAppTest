
Modules = require('../../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"
require "./option.coffee"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    responses: []
    completed: false
  }

  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
    }).validate(Template.currentData())

  @correctResponseButtons = (instance) ->
    console.log "Getting correct response buttons"
    console.log instance.$(".correct")
    return instance.$(".correct")

  @incorrectResponseButtons = (instance) ->
    console.log "INCORRECT buttons"
    console.log instance.$(".response")
    return instance.$(".response").filter ( i, elem )=> not $(elem).hasClass "correct"

Template.Lesson_view_page_multiple_choice.helpers
  optionArgs: (option)->
    return {
      option: option
      onSelected: =>
    }

  getOptions: (module, start, end) ->
    NUM_OBJECTS_PER_ROW = 3
    if not module.options then {options: []}
    getOptionData = (option, i) =>
      return {
        i: i
        option: option
        src: module.optionSrc(i)
        correct: module.isCorrectAnswer(option)
      }
    options = (getOptionData(option, i) for option, i in module.options when i >= start and i < end)
    console.log "OPtions", options
    return {options: options}

Template.Lesson_view_page_multiple_choice.events
  'click .js-user-selects': (event, template)->
    instance = Template.instance()
    module = Template.currentData().module
    responses = instance.state.get "responses"
    target = event.target
    console.log "Getting the target"
    console.log $(target).attr "id"

    if $(target).hasClass "correct"
      $(target).addClass "correctly-selected"
      $(target).addClass "expanded"
      console.log responses

      if $(target).attr("id") not in responses
        console.log "pushing responses"
        responses.push target

      if responses.length == module.correct_answer.length
        #@.correctSoundEffect.playAudio ()=> @.correctAudio.playWhenReady( ModulesController.readyForNextModule )
        correctResponseButtons = instance.correctResponseButtons()
        incorrectResponseButtons = instance.incorrectResponseButtons()
        console.log incorrectResponseButtons
        console.log correctResponseButtons
        #if @.audio
          #@.audio.pause()
        #if @.intro
          #@.intro.pause()

        for btn in incorrectResponseButtons
          if not $(btn).hasClass "faded"
            $(btn).addClass "faded"
      #else
        #@.correctSoundEffect.playAudio null

    else
      #@.incorrectSoundEffect.playAudio null
      $(target).addClass "incorrectly-selected"
      $(target).addClass "faded"
      
    instance.state.set "responses", responses


