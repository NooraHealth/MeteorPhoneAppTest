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
  fview.id = this.data.nh_id

    
  fview.modifier.setSize [400, 400]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]
  #fview.modifier.setTransform Transform.translate [-1000, 0, 0]

  #fview.modifier.setTransform Transform.translate [0,0,0], {duration: 1000, curve: "easeIn"}

  #if Session.get "current chapter card" == fview.id
  fview.modifier.setSize [500, 500], {duration: 1000, curve: "easeIn"}
  
  console.log fview.modifier

Tracker.autorun



