
class @LessonThumbnail

  height = 400
  width = 400
  constructor: (@lesson)->
    @.node = {}
    @.modifer = {}
    @.size = [width, height]
    @.template = Template.lessonThumbnail
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()

    @.registerEvents()

  isCurrentLesson: ()->
    return false

  registerEvents: ()->
    surface = @.surface

    surface.on "mouseout", ()=>
      @.state.halt()
      if @.isCurrentLesson()
        @.state.setTransform Transform.scale(1.15, 1.15, 1), {duration: 500, curve: "easeIn"}
      else
        @.state.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()=>
      console.log "mouseover"
      console.log @.state
      if @.isCurrentLesson()
        @.state.setTransform Transform.scale(1.20, 1.20, 1), {duration: 500, curve: "easeIn"}
      else
        @.state.setTransform Transform.scale(1.1, 1.1, 1), {duration: 500, curve: "easeIn"}

    surface.on "click", ()=>
      Router.go "ModulesSequence", {_id: @.lesson._id}

  getNode: ()->
    return @.node

  getSurface: ()->
    return @.surface

  @getHeight: ()->
    return height

  @getWidth: ()->
    return width

  buildSurface: ()->
    state = new StateModifier({
      align: [.25,.5]
      origin: [.5,.5]
      size: [400, 400]
    })

    @.node = new RenderNode()
    @.state = state

    surface = new Surface {
      size: @.size
      content: @.html
      properties: {
        padding: '10px'
        zIndex: 10
      }
    }

    @.node.add(state).add(surface)
    #surface.pipe state
    surface.pipe state
    return surface

  templateToHtml: ()->
    return Blaze.toHTMLWithData @.template, @.lesson
