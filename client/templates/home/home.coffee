Template.chapterThumbnail.helpers {
  getSize: ()->
    width = Session.get "chapter card width"
    height = Session.get "chapter card height"
    return [400,400]
}

Template.home.helpers {
  getTranslate: ()->
    console.log "getting the translate"
    width = Session.get "chapter card width"
    cardsComplete = Session.get "num cards complete"
    return [-1 * width * (cardsComplete + 1), 0, 0]
}
