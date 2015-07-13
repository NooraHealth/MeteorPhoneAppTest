class @LessonsView
  constructor: (@parent, @lessons)->
    @.scroll = @.buildScrollview()
    @.surfaces = []
    @.scroll.sequenceFrom(@.surfaces)
    #@.parent.add @.scroll

  getRenderable: ()->
    return @.scroll

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
    direction = @.direction()

    scroll = new Scrollview {
      direction: direction
      size: [true, height]
      paginated: true
    }

    return scroll

  addThumbnail: (index)->
    lesson = @.lessons[index]
    thumb = new LessonThumbnail(lesson)
    surface = thumb.getSurface()
    node = thumb.getNode()
    surface.pipe @.scroll
    @.surfaces.push node


