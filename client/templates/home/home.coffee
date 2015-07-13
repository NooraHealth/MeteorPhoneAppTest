
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

Template.home.onRendered ()->
  if not Meteor.user()
    return

  #lightbox = FView.byId "lightbox"
  #lightbox.view.setOptions {
      ##inTransform: Transform.translate 600, 0, 0
      ##showOrigin: [.5,.5]
      ##inTransform: Transform.scale(1.1, 1.1, 1)
      #inTransition: {duration: 1500, curve: 'easeIn'}
      #outTransition: {duration: 1500, curve: 'easeOut'}
      #inAlign: [2,.5]
      #outAlign: [-2, .5]
      #showAlign: [.5,.5]
      #overlap: true
    #}
  scrollView = new LessonsView(Template.currentData().lessons)
  lightbox = FView.byId "lightbox"
  lightbox.view.show scrollView
  lessons = Template.currentData().lessons
  getTimeout = (i)->
    return Timer.setTimeout () =>
      scrollView.addThumbnail i
    , 1000

  for lesson, i in lessons
    getTimeout(i)()


  console.log scrollView

  #lessonsComplete = Meteor.user().getCompletedLessons().length
  #lessons = Session.get "lessons sequence"
  #width = Session.get "lesson card width"
  #height = Session.get "lesson card height"
  #scrollview = FView.byId "scrollview"
  #if !lessons
    #return

  #scrollview.modifier.setOrigin [.5, .5]
  #if Meteor.Device.isPhone()
    #scrollview.modifier.setAlign [.5, .5]
  #else
    #scrollview.modifier.setAlign [.25, .5]
    
  #if lessonsComplete < lessons.length
    #if Meteor.Device.isPhone()
      #scrollview.view.setPosition width * (lessonsComplete)
    #else
      #scrollview.view.setPosition width * (lessonsComplete - 1)

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
        return false
      else
        return @._id == lessons[numLessonsComplete]._id
