class @LessonsView
  constructor: (@lessons)->
    @.view = @.buildScrollview()
    @.surfaces = []
    console.log @.view
    @.view.view.sequenceFrom(@.surfaces)

  direction: ()->
    if Meteor.Device.isPhone()
      return 1
    else
      return 0

  buildScrollview: ()->
    height = LessonThumbnail.getHeight()
    scroll = FView.byId "scroll"
    console.log scroll
    scroll.view._optionsManager.setOptions {
      direction: @.direction()
      size: [undefined, height]
      paginated: true
    }
    console.log scroll
    return scroll

  addThumbnail: (index)->
    lesson = @.lessons[index]
    thumb = new LessonThumbnail(lesson).getSurface()
    thumb.pipe @.view
    console.log "Pushing this thumb"
    console.log thumb
    @.surfaces.push thumb


