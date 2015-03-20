Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    $(event.target).toggleClass "selected"
