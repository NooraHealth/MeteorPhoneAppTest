Template.registerHelper "shouldBeRendered", ()->
  controller = Scene.get().getModuleController()
  return controller.shouldBeRendered @

