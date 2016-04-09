
Modules = require('../../../../api/modules/modules.coffee').Modules
ContentInterface = require('../../../../api/content/ContentInterface.coffee').ContentInterface
require "./scenario.html"
    
Template.Lesson_view_page_scenario.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
    }).validate(Template.currentData())

    @data = Template.currentData()
    @NORMAL = Template.currentData().module?.options[0]
    @CALLDOC = Template.currentData().module?.options[1]
    @EMERGENCY = Template.currentData().module?.options[2]

  #set the state
  @state = new ReactiveDict()
  @state.setDefault {
    selected: []
    complete: false
  }

  @questionComplete = ->
    return @state.get "complete"

  @sharedButtonClasses = "response button-big button button-fill scenario-btn"

  @responseClasses = (option) ->
    selected = @state.get "selected"
    isCorrectAnswer = @data.module.isCorrectAnswer option
    console.log "getting response classes", option
    console.log "Selected", selected
    console.log "Question completE", @questionComplete()
    console.log "isCorrectAnswer", isCorrectAnswer
    if @questionComplete()
      console.log "THE QUESTION IS COMPLET!"
      if isCorrectAnswer
        console.log @data.correctlySelectedClasses
        return @data.correctlySelectedClasses
      else
        console.log @data.incorrectClasses
        return @data.incorrectClasses
    else if option in selected
      console.log "#{@data.incorrectlySelectedClasses} #{@data.incorrectClasses}"
      return "#{@data.incorrectlySelectedClasses} #{@data.incorrectClasses}"
    else return ""
      
  @getNormalButtonClasses = ->
    console.log "NORMAL"
    classes = "#{@responseClasses(@NORMAL)} #{@sharedButtonClasses} color-green"
    console.log classes
    return classes

  @getCallDoctorButtonClasses = ->
    console.log "DOCT"
    classes = "#{@responseClasses(@CALLDOC)} #{@sharedButtonClasses} color-yellow"
    console.log classes
    return classes

  @getEmergencyButtonClasses = ->
    console.log "EMERGE"
    classes = "#{@responseClasses(@EMERGENCY)} #{@sharedButtonClasses} color-red"
    console.log classes
    return classes

  @getOnSelected = (instance, module, option) ->
    return (event) ->
      selected = instance.state.get "selected"
      if option not in selected
        selected.push option
        instance.state.set "selected", selected
        if module.isCorrectAnswer option
          instance.state.set "complete", true


Template.Lesson_view_page_scenario.helpers
  normalButtonArgs: ->
    instance = Template.instance()
    return {
      attributes: {
        class: instance.getNormalButtonClasses()
      }
      content: '<i class="fa fa-home fa-2x"></i> NORMAL'
      onClick: instance.getOnSelected( instance, instance.data.module, instance.NORMAL)
    }

  callDoctorButtonArgs: ->
    instance = Template.instance()
    return {
      attributes: {
        class: instance.getCallDoctorButtonClasses()
      }
      content: '<i class="fa fa-phone fa-2x"></i> CALL DOCTOR'
      onClick: instance.getOnSelected( instance, instance.data.module, instance.CALLDOC)
    }

  emergencyButtonArgs: ->
    instance = Template.instance()
    return {
      attributes: {
        class: instance.getEmergencyButtonClasses()
      }
      content: '<i class="fa fa-ambulance fa-2x"></i> EMERGENCY'
      onClick: instance.getOnSelected( instance, instance.data.module, instance.EMERGENCY)
    }
