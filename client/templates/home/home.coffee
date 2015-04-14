Template.chapterThumbnail.helpers {
  getSize: ()->
    width = Session.get "chapter card width"
    height = Session.get "chapter card height"
    currentCard = Session.get "current chapter card"
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
    console.log "cards Compete: ", cardsComplete
    console.log width
    return Transform.translate [-1 * width * (cardsComplete + 1),0, 0]
}


Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.home.rendered = ()->
  console.log this
  console.log FView.byId "scrollview"
  fview = FView.from this


Template.chapterThumbnail.rendered= ()->
  fview = FView.from this
  fview.id = this.data.nh_id

  fview.modifier.setSize [400, 400]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]

  #fview.modifier.setTransform Transform.translate [0,0,0]

  #if Session.get "current chapter card" == fview.id
  #fview.modifier.setSize [500, 500], {duration: 1000, curve: "easeIn"}
  #fview.modifier.setTransform Transform.scale(1.5, 1.5, 1.5), {duration: 1000, curve: "easeIn"}
  
  console.log fview.modifier

  this.autorun ()->
#THIS IS WHERE YOU PUT AUTORUN




