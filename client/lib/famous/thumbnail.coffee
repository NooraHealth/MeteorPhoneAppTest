
class @LessonThumbnail

  height = 400
  width = 400
  constructor: (@lesson)->
    @.node = {}
    @.modifer = {}
    @.size = [width, height]
    @.template = Template.lessonThumbnail
    @.html = @.templateToHtml()
    [@.node, @.surface, @.state] = @.buildSurface()

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
    targetSize = [400, 400]
    targetAlign = [.25, .5]
    targetOrigin = [.5, .5]
    
    state = new StateModifier({
    })
    
    #state.setTransform Transform.scale(.25,.25,.25)

    node = new RenderNode()
    state = state

    surface = new Surface {
      size: @.size
      content: @.html
      properties: {
        padding: '10px'
        zIndex: 10
      }
    }

    node.add(state).add(surface)
    #surface.pipe state
    surface.pipe state
    return [node, surface, state]

  templateToHtml: ()->
    return Blaze.toHTMLWithData @.template, @.lesson
