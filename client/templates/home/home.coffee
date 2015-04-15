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

}


Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.home.rendered = ()->
  cards = FView.byId "cardLayout"
  width = Session.get "chapter card width"
  cardsComplete = Session.get "current chapter card index"
  cards.modifier.setTransform Transform.translate(-1 * width * cardsComplete ,0, 0), {duration: 2000, curve: "easeIn"}

Template.chapterThumbnail.rendered= ()->
  fview = FView.from this
  chapters = Session.get "chapters sequence"
  currentChapterIndex = Session.get "current chapter card index"
  currentChapter = chapters[currentChapterIndex]
  fview.id = this.data.nh_id

  fview.modifier.setSize [400, 400]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]

  if fview.id == currentChapter.nh_id
    
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 1000, curve: "easeIn"}
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface = fview.surface or fview.view
    surface.setProperties {zIndex: 10}

    #Listen to the surface's deploy event to know when it has
    #been inserted into the DOM, after which jquery queries will 
    #work
    surface.on "deploy", ()->
      console.log "DEPLOYYYYY"
      $("#"+fview.id).find(".chapter-overlay").addClass "hidden"

    surface.on "mouseout", ()->
      fview.modifier.halt()
      fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()->
      fview.modifier.halt()
      fview.modifier.setTransform Transform.scale(1.25, 1.25, 1.25), {duration: 500, curve: "easeIn"}


  this.autorun ()->
#THIS IS WHERE YOU PUT AUTORUN




