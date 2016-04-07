
Modules = require('../../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"
require "./option.coffee"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    completed: false
    numCorrectResponses: 0
    optionAttributes: {} #map of template data for the module options
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

  @getOnSelectedCallback = (module, templateInstance) ->
    console.log "getting the onSelected callback"
    return (option) ->
      selected = templateInstance.state.get "selectedOptions"
      console.log "this is selected", selected
      if option not in selected
        selected.push option
        templateInstance.state.set "selectedOptions", selected

  @autorun (arg)=>
    console.log "Rerunning the attributes"
    console.log arg
    instance = @
    module = Template.currentData().module
    data = instance.data
    map = {}

    getClasses = (option) ->
      selected = instance.state.get "selectedOptions"
      isCorrect = module.isCorrectAnswer option
      console.log "isCorrect", isCorrect
      classes = 'image-choice'
      console.log "Getting the classes"
      console.log selected
      console.log option
      if option in selected
        if isCorrect
          classes += " #{data.correctlySelectedClasses}"
        else
          classes += " #{data.incorrectlySelectedClasses}"
          classes += " #{data.incorrectClasses}"
      else if instance.state.get "completed"
        classes += " #{data.incorrect}"
      return classes
    
    mapData = (option, i) ->
      map[option] = {
        src: module.optionSrc(i)
        class: getClasses(option)
      }

    mapData(option, i) for option, i in module.options
    instance.state.set "optionAttributes", map
    templateData = instance.state.get "optionAttributes"

Template.Lesson_view_page_multiple_choice.helpers
  optionArgs: (option) ->
    instance = Template.instance()
    attributes = instance.state.get "optionAttributes"
    module = instance.data.module
    console.log "getting the attributes", attributes
    return {
      attributes: attributes[option]
      onSelected: instance.getOnSelectedCallback module, instance
      option: option
    }

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

