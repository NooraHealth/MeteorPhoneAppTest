Template.nextBtn.events
  "click #nextbtn": ()->
    ModuleSequence.get().gotToNextModule()

Template.nextBtn.helpers
  allModulesComplete: ModuleSequence.get().allModulesComplete

  isHidden: NextModuleBtn.get().isHidden

  id: NextModuleBtn.get().getId
