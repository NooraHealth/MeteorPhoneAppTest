class @LessonsView
  constructor: (@lessons)->
    @.scroll = @.buildScrollview()
    @.surfaces = []
    console.log @.scroll
    @.scroll.view.sequenceFrom(@.surfaces)

  direction: ()->
    if Meteor.Device.isPhone()
      return 1
    else
      return 0

  buildScrollview: ()->
    height = LessonThumbnail.getHeight()
    scroll = FView.byId "scroll"
    direction = @.direction()
    scroll.view._optionsManager.setOptions {
      direction: direction
      size: [undefined, height]
      paginated: true
    }
    return scroll

  addThumbnail: (index)->
    console.log "Adding this lesson:", index
    lesson = @.lessons[index]
    console.log lesson
    thumb = new LessonThumbnail(lesson).getSurface()
    console.log lesson
    thumb.pipe @.scroll.view
    @.surfaces.push thumb


