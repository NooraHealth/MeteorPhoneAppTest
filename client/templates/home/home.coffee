
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
  cardsComplete = Meteor.user().profile.chapters_complete.length
  chapters = Session.get "chapters sequence"
  if cardsComplete < chapters.length
    cards.modifier.setTransform Transform.translate(-1 * width * cardsComplete ,0, 0), {duration: 2000, curve: "easeIn"}

Template.chapterThumbnail.onRendered ()->
  fview = FView.from this
  chaptersComplete = Meteor.user().profile.chapters_complete
  chapters = Session.get "chapters sequence"
  console.log "Chapters sequence: ", chapters
  if chaptersComplete.length == chapters.length
    currentChapterId = ""
  else if chaptersComplete.length>0
    currentChapterId= chapters[chaptersComplete.length].nh_id
  else
    currentChapterId = chapters[0].nh_id

  fview.id = this.data.nh_id

  fview.modifier.setSize [400, 400]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]
  
  surface = fview.surface or fview.view
  if fview.id == currentChapterId
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 1000, curve: "easeIn"}

  if fview.id == currentChapterId or completedChapter(fview.id)
    
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface.setProperties {zIndex: 10}

    surface.on "mouseout", ()->
      fview.modifier.halt()
      if fview.id== currentChapterId
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

#Template.chapterThumbnail.helpers {
  #imageSource: ()->
    #mediaUrl = Session.get "media url"
    #console.log "getting the image src", mediaUrl + @.image
    #return mediaUrl + @.image
    ##return "https://noorahealth-development.s3-west-1.amazonaws.com/" + @.image

#}
completedChapter = (nh_id)->
  chaptersComplete = Meteor.user().profile.chapters_complete
  return nh_id in chaptersComplete

