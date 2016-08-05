
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
      "replayButton.onClick": {type: Function}
      "replayButton.shouldShow": {type: Boolean}
      "replayButton.text": {type: String}
      "nextButton.onClick": {type: Function}
      "nextButton.onRendered": {type: Function}
      "nextButton.animated": {type: Boolean}
      "nextButton.text": {type: String}
      "progressBar.percent": {type: String}
      "progressBar.shouldShow": {type: Boolean}
      language: {type: String}
    }).validate Template.currentData()

Template.Lesson_view_page_footer.helpers
  goHomeButtonArgs: (data) ->
    classes = 'link gohome-btn button footer-button color-green button-rounded button-fill'
    return {
      attributes: {
        id: "homeBtn"
        class: classes
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
      }
      content: data.text
      onClick: data.onClick
    }



