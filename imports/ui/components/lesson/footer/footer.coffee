
require '../../shared/button.coffee'
require './paginator.coffee'
require './footer.html'

Template.Lesson_view_page_footer.onCreated ->
  # data context validation
  @autorun =>
    console.log Template.currentData()
    new SimpleSchema({
      "homeButton.onClick": {type: Function}
      "replayButton.onClick": {type: Function}
      "replayButton.shouldShow": {type: Function}
      "nextButton.onClick": {type: Function}
      "nextButton.onRendered": {type: Function}
      "nextButton.animated": {type: Boolean}
      "nextButton.text": {type: String}
      "pages.$.current": {type: Boolean}
      "pages.$.completed": {type: Boolean}
      "pages.$.index": {type: Number}
    }).validate Template.currentData()

Template.Lesson_view_page_footer.helpers
  goHomeButtonArgs: (data) ->
    return {
      attributes: {
        class: 'link gohome-btn button footer-button color-green button-rounded button-fill'
      }
      content: '<i class="fa fa-home fa-2x"></i> HOME'
      onClick: data.onClick
    }
    
  nextButtonArgs: (data) ->
    instance = Template.instance()
    classes = 'link next-module-btn footer-button button color-blue button-fill swiper-button-next'
    if data.animated then classes += ' slide-up'
    return {
      attributes: {
        class: classes
      }
      content: data.text + '<i class="fa fa-arrow-right fa-2x"></i>'
      onClick: data.onClick
      onRendered: data.onRendered
    }

  nextButtonWrapperClasses: (animated) ->
    classes = 'next-button-wrapper'
    if animated then classes += ' animate-scale'
    return classes

  shouldShow: (data) ->
    return data.shouldShow()

  replayButtonArgs: (data) ->
    classes = 'link button button-rounded color-pink button-fill'
    return {
      attributes: {
        class: classes
      }
      content: '<i class="fa fa-repeat fa-2x"></i>'
      onClick: data.onClick
    }

  paginatorArgs: (pages) ->
    return {
      pages: pages
    }
