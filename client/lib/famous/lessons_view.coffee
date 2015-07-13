class @LessonsView
  constructor: (@parent, @lessons)->
    [@.node, @.scroll, @.modifier] = @.buildScrollview()
    @.surfaces = []
    @.scroll.sequenceFrom(@.surfaces)
    @.currentLesson = @.getCurrentLessonIndex()
    #@.parent.add @.scroll

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

  addThumbnail: (index)->
    lesson = @.lessons[index]
    thumb = new LessonThumbnail(lesson)
    surface = thumb.getSurface()
    node = thumb.getNode()
    surface.pipe @.scroll
    @.surfaces.push node


