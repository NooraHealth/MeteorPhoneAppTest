Template.chapterThumbnail.helpers {
  getSize: ()->
    console.log "returning the size"
    width = Session.get "chapter card width"
    height = Session.get "chapter card height"
    return [400,400]
}
