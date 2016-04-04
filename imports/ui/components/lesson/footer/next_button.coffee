  
Template.nextBtn.events
  "click": ()->
    console.log "Clicked next!"
    btn = $("#next")
    btn.removeClass "active-state"
    Scene.get().goToNextModule()


