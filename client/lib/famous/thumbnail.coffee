
class @LessonThumbnail

  height = 400
  width = 400
  constructor: ( @lesson, @shouldBeAvailableToClick )->
    @.node = {}
    @.modifer = {}
    @.size = [width, height]
    @.template = Template.lessonThumbnail
    @.html = @.templateToHtml()
    [@.node, @.surface, @.state] = @.buildSurface()

    if @.shouldBeAvailableToClick
      @.registerEvents()

  isCurrentLesson: ()->
    return false

  makeAvailableToClick: ()->
    @.shouldBeAvailableToClick = true
    @.state.setOpacity 1
    @.registerEvents()

  expand: ()->
    @.state.setTransform Transform.scale(1.05, 1.05, 1), {duration: 500, curve: "easeIn"}

  registerEvents: ()->
    surface = @.surface

    surface.on "mouseout", ()=>
      @.state.halt()
      if @.isCurrentLesson()
        @.expand()
      else
        @.state.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()=>
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
    @.state = state

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
