
Modules = require('../../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"
require "./option.coffee"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    completed: false
    numCorrectResponses: 0
    optionTemplateData: {} #map of template data for the module options
    selectedOptions: [] #array of options that have been selected
  }

  @autorun =>
    console.log "Validating mc", Template.currentData()
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @autorun =>
    instance = Template.instance()
    module = Template.currentData().module
    data = instance.data
    map = {}

    getOnSelectedCallback = (module, templateInstance) ->
      return (option) ->
        optionData = templateInstance.state.get("optionTemplateData")[option]
        console.log "THE TEMPLATE DATA O FHT OPTION"
        if option.correct
          classes = templateInstance.initialOptionClasses + templateInstance.data.correctlySelectedClasses
          templateData.set
          num = state.get "numCorrectResponses"
          state.set "numCorrectResponses", ++num
          if num == module.correct_answer.length
            state.set "completed", true

    getClasses = (option) ->
      selected = instance.state.get "selectedOptions"
      isCorrect = module.isCorrectAnswer option
      classes = 'image-choice'
      if option in selected
        if isCorrect
          classes += " #{data.correctlySelectedClasses}"
        else
          classes += " #{data.incorrectlySelectedClasses}"
      else if instance.state.get "completed"
        classes += " #{data.incorrect}"
      return classes
    
    mapData = (option, i) ->
      map[option] = {
        attributes: {
          src: module.optionSrc(i)
          class: getClasses(option)
        }
        onSelected: getOnSelectedCallback module, instance
      }

    mapData(option, i) for option, i in module.options
    console.log " this is the map", map
    instance.state.set "optionTemplateData", map
    

Template.Lesson_view_page_multiple_choice.helpers
  optionArgs: (option) ->
    instance = Template.instance()
    module = instance.module
    console.log "Getting the template data for the option"
    templateData = instance.state.get "optionTemplateData"
    console.log "Here is the template data"
    console.log templateData
    return templateData[option]
    #return {
      #option: option
      #onSelected: instance.getOptionCallback(module, instance.state)
      #questionComplete: instance.state.get "completed"
    #}

  getOptions: (module, start, end) ->
    instance = Template.instance()
    NUM_OBJECTS_PER_ROW = 3
    #if not module.options then {options: []}
    #getOptionData = (option, i) =>
      #return {
        #i: i
        #option: option
        #src: module.optionSrc(i)
        #correct: module.isCorrectAnswer(option)
        #correctlySelectedClasses: {type: String}
        #incorrectClasses: {type: String}
        #incorrectlySelectedClasses: {type: String}
      #}
    #options = (getOptionData(option, i) for option, i in module.options when i >= start and i < end)
    return {options: module.options.slice(start, end)}

