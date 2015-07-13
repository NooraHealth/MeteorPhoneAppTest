class @LessonsView
  constructor: (@parent, @lessons)->
    [@.node, @.scroll, @.modifier] = @.buildScrollview()
    @.surfaces = []
    @.scroll.sequenceFrom(@.surfaces)
    #@.parent.add @.scroll

  getRenderable: ()->
    return @.node

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
    width = LessonThumbnail.getWidth()
    direction = @.direction()

    modifier = new StateModifier {
      align: [.25,.5]
      origin: [.5,.5]
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


