
Template.home.helpers {
  displayTrophy: ()->
    return Session.get "display trophy"
}
Template.lessonThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.home.onRendered ()->
  if not Meteor.user()
    return
  cards = FView.byId "cardLayout"
  width = Session.get "lesson card width"

  lessonsComplete = Meteor.user().getCompletedLessons().length
  console.log "CARDS COMPLETE",lessonsComplete
  lessons = Session.get "lessons sequence"
  scrollView = FView.byId("cardLayout").view
  console.log "This is the scrollview"
  console.log scrollView
  
  #if lessonsComplete < lessons.length
    #cards.modifier.setTransform Transform.translate(-1 * width * lessonsComplete ,0, 0), {duration: 2000, curve: "easeIn"}
  if lessonsComplete < lessons.length
    scrollView.setPosition width * lessonsComplete
    #cards.modifier.setTransform Transform.translate(0, -1 * width * lessonsComplete ,0), {duration: 2000, curve: "easeIn"}

Template.lessonThumbnail.onRendered ()->
  fview = FView.from this
  lessonsComplete = Meteor.user().getCompletedLessons()
  lessons = Session.get "lessons sequence"
  if lessonsComplete.length == lessons.length
    currentlessonId = ""
  else if lessonsComplete.length>0
    currentlessonId= lessons[lessonsComplete.length].nh_id
  else
    currentlessonId = lessons[0].nh_id

  fview.id = this.data.nh_id

  fview.modifier.setSize [400, 400]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]
  
  surface = fview.surface or fview.view
  if fview.id == currentlessonId
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 1000, curve: "easeIn"}

  if fview.id == currentlessonId or Meteor.user().hasCompletedLesson(fview.id)
    
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface.setProperties {zIndex: 10}

    surface.on "mouseout", ()->
      fview.modifier.halt()
      if fview.id== currentlessonId
        fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 500, curve: "easeIn"}
      else
        fview.modifier.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()->
      fview.modifier.halt()
      fview.modifier.setTransform Transform.scale(1.25, 1.25, 1.25), {duration: 500, curve: "easeIn"}

    surface.on "click", ()->
      Router.go "ModulesSequence", {nh_id: fview.id}
  
  else
    fview.modifier.setOpacity .5

#Template.lessonThumbnail.helpers {
  #imageSource: ()->
    #mediaUrl = Session.get "media url"
    #console.log "getting the image src", mediaUrl + @.image
    #return mediaUrl + @.image
    ##return "https://noorahealth-development.s3-west-1.amazonaws.com/" + @.image

#}

