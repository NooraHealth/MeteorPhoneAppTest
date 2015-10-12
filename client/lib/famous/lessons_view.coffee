class @LessonsView
  @get: ( parent, lessons )=>
    console.log @.view
    if not @.view
      @.view = new PrivateClass parent, lessons
    console.log @.view
    return @.view

  class PrivateClass
    constructor: ( @parent )->
      @.surfaces = []

      [@.node, @.scroll, @.modifier] = @.buildScrollview()
      @.scroll.sequenceFrom(@.surfaces)

    init: ( lessons )->
      @.lessons = lessons
      @.thumbs = []
      @.surfaces = []

      @.currentLesson = 0
      for lesson, i in @.lessons
        @.addThumbnail lesson, i

      @.scroll.sequenceFrom @.surfaces

      #@.parent.add @.scroll

    currentLessonId: ()=>
      return @.lessons[@.currentLesson]._id

    getRenderable: ()=>
      return @.node

    getCurrentLessonIndex: ()=>
      lessonsComplete = Meteor.user().getCompletedLessons().length
      if lessonsComplete < @.lessons.length
        return lessonsComplete
      else
        return 0

    direction: ()=>
      if Meteor.Device.isPhone()
        return 1
      else
        return 0

    goToNextPage: ()=>
      @.goToPage @.currentLesson + 1

    goToPage: (i)=>
      @.currentLesson = i
      console.log @.thumbs
      thumb = @.thumbs[@.currentLesson]
      thumb.expand()
      thumb.makeAvailableToClick()
      @.scroll.goToPage i

    buildScrollview: ()->
      height = LessonThumbnail.getHeight()
      width = LessonThumbnail.getWidth() * 20
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

    addThumbnail: ( lesson, index )->
      console.log "Adding thumbnail@indeindeindexxx"
      shouldBeAvailableToClick = @.shouldBeAvailableToClick lesson
      thumb = new LessonThumbnail lesson, shouldBeAvailableToClick

      if index == @.currentLesson
        console.log "Expanding"
        thumb.expand()
      else if not shouldBeAvailableToClick
        thumb.state.setOpacity .65

      surface = thumb.getSurface()
      node = thumb.getNode()
      surface.pipe @.scroll
      @.surfaces.push node
      @.thumbs.push thumb

    shouldBeAvailableToClick: ( lesson )->
      completedLessons = Meteor.user().getCompletedLessons()
      indexOf = @.lessons.indexOf lesson
      if ( lesson in completedLessons ) or ( indexOf == @.currentLesson )
        console.log "RETURNING TRUe"
        return true
      else
        return false



