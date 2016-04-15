
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
      onWrongAnswer: {type: Function}
      onCorrectAnswer: {type: Function}
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
    if @questionComplete()
      if isCorrectAnswer
        return @data.correctlySelectedClasses
      else
        return @data.incorrectClasses
    else if option in selected
      return "#{@data.incorrectlySelectedClasses} #{@data.incorrectClasses}"
    else return ""
      
  @getNormalButtonClasses = ->
    classes = "#{@responseClasses(@NORMAL)} #{@sharedButtonClasses} color-green"
    return classes

  @getCallDoctorButtonClasses = ->
    classes = "#{@responseClasses(@CALLDOC)} #{@sharedButtonClasses} color-yellow"
    return classes

  @getEmergencyButtonClasses = ->
    classes = "#{@responseClasses(@EMERGENCY)} #{@sharedButtonClasses} color-red"
    return classes

  @getOnSelected = (instance, module, option) ->
    return (event) ->
      selected = instance.state.get "selected"
      if option not in selected
        selected.push option
        instance.state.set "selected", selected
      if module.isCorrectAnswer option
        instance.state.set "complete", true
        instance.data.onCorrectAnswer module
      else
        instance.data.onWrongAnswer module



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
