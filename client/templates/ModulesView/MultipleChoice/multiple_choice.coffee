Template.multipleChoiceModule.helpers
  secondRow: ()->
    return @.getOptions 3, 6
  firstRow: ()->
    return @.getOptions 0, 3
  module: ()->
    return @

Template.multipleChoiceModule.events
  'click .js-user-selects': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target


