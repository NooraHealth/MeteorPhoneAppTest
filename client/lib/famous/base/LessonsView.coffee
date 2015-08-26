
class @LessonsView
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @
    @.setOrigin .5, .5, .5
     .setMountPoint .5, .5, .5
     .setAlign .5, .5, .5

    @.thumbnails = []
    @.setLessons [{title: "SampleLesson"}]
    console.log "Setting the lessons"

  setLessons: (lessons)->
    console.log lessons
    for lesson in lessons
      console.log "Adding alesson"
      @.addThumbnail lesson

  addThumbnail: (lesson)->
    thumb = new LessonThumbnail(lesson)
    console.log thumb
    @.addChild thumb
    @.thumbnails.push thumb

  getRenderable: ()->
    return @.node

  getCurrentLessonIndex: ()->
    lessonsComplete = Meteor.user().getCompletedLessons().length
    if lessonsComplete < @.lessons.length
      return lessonsComplete
    else
      return 0

  direction: ()->
    if Meteor.Device.isPhone()
      return 1
    else
      return 0

  goToNextPage: (i)->
    @.scroll.goToNextPage i

  goToPage: (i)->
    @.scroll.goToPage i

  buildScrollview: ()->
    height = LessonThumbnail.getHeight()
    width = LessonThumbnail.getWidth() * (@.lessons.length+1)
    direction = @.direction()

    modifier = new StateModifier {
      align: [.5,.75]
    }

    node = new RenderNode modifier
    scroll = new Scrollview {
      direction: direction
      size: [width, height]
      paginated: true
    }
    node.add(scroll)

    return [node, scroll, modifier]
