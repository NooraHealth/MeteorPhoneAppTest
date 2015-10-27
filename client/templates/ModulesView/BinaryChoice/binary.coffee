
Template.binaryChoiceModule.events
  'click .response': (event, template)->
    sequenceController = Scene.get().modulesSequenceController()
    sequenceController.notifyResponseRecieved event.target

