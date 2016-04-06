
Modules = require('../../../../api/modules/modules.coffee').Modules
require '../../button.html'
require './footer.html'

Template.Lesson_view_page_footer.onCreated ->
  # data context validation
  @autorun =>
    new SimpleSchema({
      onHomeButtonClicked: {type: Function}
      onNextButtonClicked: {type: Function}
      onReplayButtonClicked: {type: Function}
      pages: {type: [Object]}
    }).validate Template.currentData()

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
    onClick = Template.currentData().onReplayButtonClicked
    return {
      attributes: {
        class: 'link next-module-btn footer-button button color-blue button-fill swiper-button-next'
      }
      content: text + '<i class="fa fa-repeat fa-2x"></i>'
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


