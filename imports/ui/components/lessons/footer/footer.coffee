
require '../../shared/button.coffee'
require './progress.coffee'
require './footer.html'

Template.Lesson_view_page_footer.onCreated ->
  # data context validation
  @autorun =>
    new SimpleSchema({
      "homeButton.onClick": {type: Function}
      "homeButton.shouldShow": {type: Boolean}
      "homeButton.text": {type: String}
      "homeButton.disabled": {type: Boolean}
      "replayButton.onClick": {type: Function}
      "replayButton.shouldShow": {type: Boolean}
      "replayButton.text": {type: String}
      "replayButton.disabled": {type: Boolean}
      "nextButton.onClick": {type: Function}
      "nextButton.onRendered": {type: Function, optional: true}
      "nextButton.animated": {type: Boolean}
      "nextButton.text": {type: String}
      "nextButton.disabled": {type: Boolean}
      "progressBar.percent": {type: String}
      "progressBar.shouldShow": {type: Boolean}
      language: {type: String}
      visible: {type: Boolean, optional: true}
    }).validate Template.currentData()

Template.Lesson_view_page_footer.helpers
  goHomeButtonArgs: (data) ->
    classes = 'link gohome-btn button footer-button color-green button-rounded button-fill'
    return {
      attributes: {
        id: "homeBtn"
        class: classes
        disabled: data.disabled
      }
      content: data.text
      onClick: data.onClick
    }
    
  nextButtonArgs: (data) ->
    instance = Template.instance()
    classes = 'link footer-button button color-orange button-fill'
    #if data.animated then classes += ' slide-up'
    return {
      attributes: {
        id: "nextModuleBtn"
        class: classes
        disabled: data.disabled
      }
      content: data.text
      onClick: data.onClick
      onRendered: data.onRendered
    }

  nextButtonWrapperClasses: (animated) ->
    classes = ''
    if animated then classes += ' animate-scale'
    return classes

  replayButtonArgs: (data) ->
    classes = 'link footer-button button button-rounded color-pink button-fill'
    return {
      attributes: {
        id: "replayBtn"
        class: classes
        disabled: data.disabled
      }
      content: data.text
      onClick: data.onClick
    }



