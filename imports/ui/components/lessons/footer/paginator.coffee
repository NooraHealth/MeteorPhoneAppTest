

require './paginator.html'

Template.Lesson_view_page_footer_paginator.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      "pages.$.current": {type: Boolean}
      "pages.$.completed": {type: Boolean}
      "pages.$.incorrect": {type: Boolean}
      "pages.$.index": {type: Number}
    }).validate Template.currentData()

Template.Lesson_view_page_footer_paginator.helpers
  colorClass: ( page )->
    if page.completed and page.incorrect
      return "red"
    else if page.completed
      return "green"
