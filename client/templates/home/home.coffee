
Template.home.helpers {
  displayTrophy: ()->
    return Session.get "display trophy"
}
Template.chapterThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.home.onRendered ()->
  cards = FView.byId "cardLayout"
  width = Session.get "chapter card width"
  cardsComplete = Session.get "current chapter index"
  cards.modifier.setTransform Transform.translate(-1 * width * cardsComplete ,0, 0), {duration: 2000, curve: "easeIn"}

  #controller = FView.from this
  #console.log "CONTROLLER: ", controller

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

  #fview.preventDestroy()

  if fview.id == currentChapter.nh_id
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 1000, curve: "easeIn"}

  if fview.id == currentChapter.nh_id or completedChapter(fview.id)
    
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface.setProperties {zIndex: 10}

    surface.on "mouseout", ()->
      fview.modifier.halt()
      if fview.id== currentChapter.nh_id
        fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 500, curve: "easeIn"}
      else
        fview.modifier.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()->
      fview.modifier.halt()
      fview.modifier.setTransform Transform.scale(1.25, 1.25, 1.25), {duration: 500, curve: "easeIn"}

    surface.on "click", ()->
      console.log "going to the modules page"
      Router.go "ModulesSequence", {nh_id: fview.id}
  
  else
    fview.modifier.setOpacity .5

  
  this.autorun ()->
#THIS IS WHERE YOU PUT AUTORUN




