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
    template = Template.instance()
    console.log "getting translate"
    console.log template
    fview = FView.from template
    console.log fview
    width = Session.get "chapter card width"
    cardsComplete = Session.get "current chapter card index"
    return [-1 * width * (cardsComplete + 1),0, 0]
}


Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
    console.log "There was a click!"
    console.log fview
    console.log fview.modifier
}

Template.chapterThumbnail.rendered= ()->
  fview = FView.from this
  console.log "in the chapter thumbnail rendered: ", fview



