
require './paginator.html'

Template.Lesson_view_page_footer_paginator.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      pages: {type: [Object]}
    }).validate Template.currentData()

