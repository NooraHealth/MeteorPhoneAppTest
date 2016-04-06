
Modules = require('../../../../api/modules/modules.coffee').Modules
require '../../button.html'
require './paginator.coffee'
require './footer.html'

Template.Lesson_view_page_footer.onCreated ->
  # data context validation
  @autorun =>
    new SimpleSchema({
      "onHomeButtonClicked": {type: Function}
      "onNextButtonClicked": {type: Function}
      "onReplayButtonClicked": {type: Function}
      "lessonComplete": {type: Function}
      "pages.$.current": {type: Boolean}
      "pages.$.completed": {type: Boolean}
      "pages.$.index": {type: Number}
    }).validate Template.currentData()

  @getNextButtonText = ()=>
    data = Template.currentData()
    complete = data.lessonComplete()
    if complete then "FINISH" else "NEXT"


Template.Lesson_view_page_footer.helpers
  goHomeButtonArgs: ->
    onClick = Template.currentData().onHomeButtonClicked
    return {
      attributes: {
        class: 'link gohome-btn button footer-button color-green button-rounded button-fill'
      }
      content: '<i class="fa fa-home fa-2x"></i> HOME'
      onClick: onClick
    }
    
  nextButtonArgs: ->
    instance = Template.instance()
    text = instance.getNextButtonText()
    onClick = Template.currentData().onReplayButtonClicked
    return {
      attributes: {
        class: 'link next-module-btn footer-button button color-blue button-fill swiper-button-next'
      }
      content: text + '<i class="fa fa-arrow-right fa-2x"></i>'
    }

  replayButtonArgs: ->
    onClick = Template.currentData().onReplayButtonClicked
    return {
      attributes: {
        class: 'link button button-rounded color-pink button-fill'
      }
      content: '<i class="fa fa-repeat fa-2x"></i>'
    }

  paginatorArgs: ->
    pages = Template.currentData().pages
    return {
      pages: pages
    }


