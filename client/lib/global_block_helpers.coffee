Template.registerHelper "shouldBeRendered", ()->
  controller = Scene.get().getModuleSequenceController()
  return controller.shouldBeRendered @

