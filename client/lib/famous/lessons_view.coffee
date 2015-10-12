class @LessonsView
  @get: ( parent, lessons )=>
    console.log @.view
    @.view ?= new PrivateClass parent, lessons
    return @.view

  class PrivateClass
    constructor: (@parent, @lessons)->
      console.log "Making a new private class"
      @.thumbs = []
      @.surfaces = []
      [@.node, @.scroll, @.modifier] = @.buildScrollview()
      @.scroll.sequenceFrom(@.surfaces)

      @.currentLesson = 0
      for lesson, i in @.lessons
        @.addThumbnail lesson, i

      console.log "Sequence from"
      console.log @.surfaces
      #@.parent.add @.scroll

    currentlessonId: ()->
      return @.lessons[@.currentLesson]._id

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

    addThumbnail: ( lesson, index )->
      console.log "Adding thumbnail@indeindeindexxx"
      shouldBeAvailableToClick = @.shouldBeAvailableToClick lesson
      thumb = new LessonThumbnail lesson, shouldBeAvailableToClick

      if index == @.currentLesson
        console.log "Expanding"
        thumb.expand()
      else if not shouldBeAvailableToClick
        thumb.state.setOpacity .75

      surface = thumb.getSurface()
      node = thumb.getNode()
      surface.pipe @.scroll
      @.surfaces.push node
      console.log "Pushing thumbs!"
      console.log @.thumbs
      @.thumbs.push thumb

    shouldBeAvailableToClick: ( lesson )->
      completedLessons = Meteor.user().getCompletedLessons()
      indexOf = @.lessons.indexOf lesson
      if ( lesson in completedLessons ) or ( indexOf == @.currentLesson )
        console.log "RETURNING TRUe"
        return true
      else
        return false



