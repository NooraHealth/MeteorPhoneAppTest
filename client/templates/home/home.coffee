
Template.home.helpers {
  getDirection: ()->
    if Meteor.Device.isPhone()
      console.log "Returning 1"
      return 1
    else
      return 0

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
  #if lessonsComplete < lessons.length
    #cards.modifier.setTransform Transform.translate(-1 * width * lessonsComplete ,0, 0), {duration: 2000, curve: "easeIn"}
  #scrollview.blazeView.onViewReady ()->
  lessonsComplete = Meteor.user().getCompletedLessons().length
  lessons = Session.get "lessons sequence"
  width = Session.get "lesson card width"
  height = Session.get "lesson card height"
  
  scrollview = FView.byId "scrollview"
  console.log scrollview
  console.log scrollview.properties
  if lessonsComplete < lessons.length
    scrollview.view.setPosition width * (lessonsComplete - 1)
    if Meteor.Device.isPhone()
      #scrollview.modifier.setTransform Transform.translate(0, -.5 * height, 0), {duration: 2000, curve: "easeIn"}
    else
      scrollview.modifier.setTransform Transform.translate(-1 * width ,0, 0), {duration: 2000, curve: "easeIn"}

Template.lessonThumbnail.onRendered ()->

  lessonsComplete = Meteor.user().getCompletedLessons().length
  #if scrollview.view.getCurrentIndex() < lessonsComplete
    #scrollview.view.goToNextPage()

  fview = FView.from this

  lessons = Session.get "lessons sequence"
  if lessonsComplete == lessons.length
    currentlessonId = ""
  else
    currentlessonId= lessons[lessonsComplete].nh_id

  fview.id = this.data.nh_id

  height = Session.get "lesson card height"
  width = Session.get "lesson card width"
  fview.modifier.setSize [width, height]
  fview.modifier.setOrigin [.5, .5]
  fview.modifier.setAlign [.5, .5]
  
  surface = fview.surface or fview.view
  if fview.id == currentlessonId
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1.15), {duration: 1000, curve: "easeIn"}

  if fview.id == currentlessonId or Meteor.user().hasCompletedLesson(fview.id)
    
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface.setProperties {zIndex: 10, padding: '10px';}

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

Template.lessonThumbnail.helpers
  isCurrentLesson: ()->
    lessons = Session.get "lessons sequence"
    lessonsComplete = Meteor.user().getCompletedLessons().length
    if lessons.length == lessonsComplete
      return false
    else
      return @.nh_id == lessons[lessonsComplete].nh_id
