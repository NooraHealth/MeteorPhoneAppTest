
Template.home.helpers {
  getDirection: ()->
    if Meteor.Device.isPhone()
      return 1
    else
      return 0

  displayTrophy: ()->
    return Session.get "display trophy"

  getScrollSize: ()->
    height = Session.get "lesson card height"
    return ['true', height]

  getSize:()->
    width = Session.get "lesson card width"
    height = Session.get "lesson card height"
    return [height, width]
}
Template.lessonThumbnail.events {
  "click .card": (event, template) ->
    fview = FView.from(template)
}

Template.home.onRendered ()->
  if not Meteor.user()
    return
  console.log "In the onRendered for home template"
  lessonsComplete = Meteor.user().getCompletedLessons().length
  lessons = Session.get "lessons sequence"
  width = Session.get "lesson card width"
  height = Session.get "lesson card height"
  scrollview = FView.byId "scrollview"
  if !lessons
    return

  scrollview.modifier.setOrigin [.5, .5]
  if Meteor.Device.isPhone()
    scrollview.modifier.setAlign [.5, .5]
  else
    scrollview.modifier.setAlign [.25, .5]
    
  if lessonsComplete < lessons.length
    if Meteor.Device.isPhone()
      scrollview.view.setPosition width * (lessonsComplete)
    else
      scrollview.view.setPosition width * (lessonsComplete - 1)

Template.lessonThumbnail.onRendered ()->

  lessonsComplete = Meteor.user().getCompletedLessons().length

  fview = FView.from this

  lessons = Session.get "lessons sequence"
  if !lessons
    return
  if lessonsComplete == lessons.length
    currentlessonId = ""
  else
    currentlessonId= lessons[lessonsComplete]._id

  fview.id = this.data._id

  height = Session.get "lesson card height"
  width = Session.get "lesson card width"
  
  surface = fview.surface or fview.view
  if fview.id == currentlessonId
    fview.modifier.setTransform Transform.scale(1.15, 1.15, 1), {duration: 1000, curve: "easeIn"}

  if fview.id == currentlessonId or Meteor.user().hasCompletedLesson(fview.id)
    
    fview.modifier.setOpacity 1, {duration:500, curve: "easeIn"}
    surface.setProperties {zIndex: 10, padding: '10px';}

    surface.on "mouseout", ()->
      fview.modifier.halt()
      if fview.id== currentlessonId
        fview.modifier.setTransform Transform.scale(1.15, 1.15, 1), {duration: 500, curve: "easeIn"}
      else
        fview.modifier.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()->
      if fview.id== currentlessonId
        fview.modifier.setTransform Transform.scale(1.20, 1.20, 1), {duration: 500, curve: "easeIn"}
      else
        fview.modifier.setTransform Transform.scale(1.1, 1.1, 1), {duration: 500, curve: "easeIn"}

    surface.on "click", ()->
      Router.go "ModulesSequence", {_id: fview.id}
  
  else
    fview.modifier.setOpacity .5

Template.lessonThumbnail.helpers
  isCurrentLesson: ()->
    lessons = Session.get "lessons sequence"
    if !Meteor.user()
      return
    lessonsComplete = Meteor.user().getCompletedLessons()
    if !lessonsComplete
      return false
    numLessonsComplete = lessonsComplete.length
    if lessons.length == numLessonsComplete
      return false
    else
      if !lessons[numLessonsComplete]
        console.log "Not lessons complete"
        return false
      else
        console.log "Getting the lesson at the index"
        return @._id == lessons[numLessonsComplete]._id
