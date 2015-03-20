Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    console.log "toggeling class"
    $(event.target).toggleClass "selected"
