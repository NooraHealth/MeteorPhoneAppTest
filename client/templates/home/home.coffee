Template.chapterThumbnail.helpers {
  getSize: ()->
    width = Session.get "chapter card width"
    height = Session.get "chapter card height"
    return [width,height]

  currentCardTransform: ()->
    return Session.get "current chapter card transform"
}

Template.home.helpers {
  getTranslate: ()->
    console.log "getting the translate"
    width = Session.get "chapter card width"
    cardsComplete = Session.get "num cards complete"
    return [-1 * width * (cardsComplete + 1), 0, 0]
}

Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
    console.log "There was a click!"
    console.log fview
    console.log fview.modifier
}



