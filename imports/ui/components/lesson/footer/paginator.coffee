

require './paginator.html'

Template.Lesson_view_page_footer_paginator.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      "pages.$.current": {type: Boolean}
      "pages.$.completed": {type: Boolean}
      "pages.$.index": {type: Number}
    }).validate Template.currentData()


