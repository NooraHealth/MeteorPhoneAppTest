Template.chapterThumbnail.helpers {
  getSize: ()->
    width = Session.get "chapter card width"
    height = Session.get "chapter card height"
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
    cardsComplete = Session.get "num cards complete"
    return [-1 * width * (cardsComplete + 1),0, 0]
}

Template.home.helpers {
}

Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
    console.log "There was a click!"
    console.log fview
    console.log fview.modifier
}

Template.home.rendered = ()->
  fview = FView.byId "scrollview"



