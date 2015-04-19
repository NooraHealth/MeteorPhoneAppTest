
Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.home.onRendered ()->
  cards = FView.byId "cardLayout"
  width = Session.get "chapter card width"
  cardsComplete = Session.get "current chapter index"
  cards.modifier.setTransform Transform.translate(-1 * width * cardsComplete ,0, 0), {duration: 2000, curve: "easeIn"}
  console.log "the cards fview"

Template.chapterThumbnail.onRendered ()->
  fview = FView.from this
  chapters = Session.get "chapters sequence"
  currentChapterIndex = Session.get "current chapter index"
  currentChapter = chapters[currentChapterIndex]
  fview.id = this.data.nh_id

  fview.modifier.setSize [400, 400]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]
  
  surface = fview.surface or fview.view
  
  if completedChapter(fview.id)
    $("#"+fview.id).find(".success-overlay").removeClass "hidden"

  else if fview.id == currentChapter.nh_id
    
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 1000, curve: "easeIn"}
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface.setProperties {zIndex: 10}

    surface.on "mouseout", ()->
      fview.modifier.halt()
      fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()->
      fview.modifier.halt()
      fview.modifier.setTransform Transform.scale(1.25, 1.25, 1.25), {duration: 500, curve: "easeIn"}

    surface.on "click", ()->
      console.log "going to the modules page"
      Router.go "ModulesSequence", {nh_id: fview.id, index: 0}
  
  else
    fview.modifier.setOpacity .5

  
  this.autorun ()->
#THIS IS WHERE YOU PUT AUTORUN




