
require './paginator.html'

Template.Lesson_view_page_footer_paginator.onCreated ->
  #data context validation
  @autorun =>
    console.log "VALIDATING PAGINATOR"
    console.log "These are the pages:", Template.currentData()
    new SimpleSchema({
      "pages.$.current": {type: Boolean}
      "pages.$.completed": {type: Boolean}
      "pages.$.index": {type: Number}
    }).validate Template.currentData()
    console.log "PAGINATOR VLAIDATO"

