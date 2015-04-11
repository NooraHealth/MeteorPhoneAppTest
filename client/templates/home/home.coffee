Template.chapterThumbnail.helpers {
  getSize: ()->
    width = Session.get "chapter card width"
    height = Session.get "chapter card height"
    currentCardIndex = Session.get "current chapter card index"
    return [width,height]

  getRotateY: ()->
    return {
      value:30,
      transition: {curve: 'easeIn', duration: 1000},
      done: ()->
        console.log "rotation transformation done"
    }

  getTranslate: ()->
    width = Session.get "chapter card width"
    cardsComplete = Session.get "current chapter card index"
    return {
      #value: [-1 * width * (cardsComplete + 1),0, 0],
      value: [0,0,0],
      #transition: {curve: "easeIn", duration: 1000}
    }
}


Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.chapterThumbnail.rendered= ()->
  fview = FView.from this
  console.log "This is this in  the chapterThumbnail ", this
  fview.id = this.data.nh_id
  console.log "in the chapter thumbnail rendered: ", fview



