class @LessonsView
  constructor: (@parent, @lessons)->
    @.scroll = @.buildScrollview()
    @.surfaces = []
    console.log @.scroll
    @.scroll.sequenceFrom(@.surfaces)
    console.log @.parent
    #@.parent.add @.scroll

  getRenderable: ()->
    return @.scroll

  direction: ()->
    if Meteor.Device.isPhone()
      return 1
    else
      return 0

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
    console.log scroll

    scroll.on "deploy", ()=>
      console.log "jscrollview deployed"
      @.goToPage 5
    return scroll

  addThumbnail: (index)->
    lesson = @.lessons[index]
    thumb = new LessonThumbnail(lesson).getSurface()
    thumb.pipe @.scroll
    @.surfaces.push thumb


