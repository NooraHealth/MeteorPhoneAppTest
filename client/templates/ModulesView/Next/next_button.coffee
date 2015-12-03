  
Template.nextBtn.events
  "click": ()->
    btn = $("#next")
    btn.removeClass "active-state"
    Scene.get().goToNextModule()


