
class @LessonsView extends BaseNode
  constructor: ()->
    super

    @.STEP = .03
    @.THUMBNAILS_PER_ROW = 2
    @.MARGIN = 15
    @.EDGE_MARGIN = 0

    @.setOrigin .5, .5, .5
     .setMountPoint .5, .5, .5
     .setAlign .5, .5, .4
     #.setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.RELATIVE_SIZE
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .9, 1
     #.setAbsoluteSize @.SIZE[0], @.SIZE[1], 0
    @.domElement = new DOMElement @, {
      properties:
        "overflow-y" : "scroll"
    }

    @.thumbnails = []
    @.lessons = []

    @.positionTransitionable = new Transitionable 1
    @.requestUpdateOnNextTick()

  onUpdate: ()->
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  moveOffstage: ()->
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500, ()-> console.log "Lessons Moved OFF"
    @.hide()
    @.requestUpdateOnNextTick(@)

  moveOnstage: ()->
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500, ()-> console.log "lessons Moved ON"
    @.show()
    @.requestUpdateOnNextTick(@)

  setLessons: (lessons)->
    @.SIZE = @.getSize()
    @._grid = new Grid lessons.length, @.THUMBNAILS_PER_ROW, @.SIZE, @.MARGIN, @.EDGE_MARGIN

    for thumb in @.thumbnails
      @.removeChild @.thumbnails

    @.lessons = lessons
    @.thumbnails = []
    for lesson, index in lessons
      @.addThumbnail lesson

  addThumbnail: (lesson)->
    thumb = new LessonThumbnail(lesson)
    @.addChild thumb
    index = ( @.thumbnails.push thumb ) - 1

    numRows = @._grid.getNumRows()
    horizontalSpace = @._grid.getAvailableSpace Grid.X
    verticalSpace = @._grid.getAvailableSpace Grid.Y

    xDimension = horizontalSpace / @.THUMBNAILS_PER_ROW
    yDimension = verticalSpace / @.THUMBNAILS_PER_ROW

    thumb.setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
    thumb.setAbsoluteSize xDimension, yDimension, 1

    row = @._grid.getRow index
    col = @._grid.getCol index
    location = @._grid.location row, col, [ xDimension, yDimension ]
    console.log "LOCATION"
    console.log location

    thumb.setPosition location.x, location.y, 0

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
