
class @LessonThumbnail

  height = 400
  width = 400
  constructor: (@lesson)->
    @.size = [width, height]
    @.template = Template.lessonThumbnail
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()
    @.modifier = @.node._object
    @.registerEvents()

  isCurrentLesson: ()->
    return false

  registerEvents: ()->
    surface = @.surface
    currentlessonId = ""
    console.log @.node

    surface.on "mouseout", ()=>
      @.modifier.halt()
      if @.isCurrentLesson()
        @.modifier.setTransform Transform.scale(1.15, 1.15, 1), {duration: 500, curve: "easeIn"}
      else
        @.modifier.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    surface.on "mouseover", ()=>
      if @.isCurrentLesson()
        @.modifier.setTransform Transform.scale(1.20, 1.20, 1), {duration: 500, curve: "easeIn"}
      else
        @.modifier.setTransform Transform.scale(1.1, 1.1, 1), {duration: 500, curve: "easeIn"}

    surface.on "click", ()=>
      Router.go "ModulesSequence", {_id: @.lesson._id}

  getSurface: ()->
    return @.surface

  @getHeight: ()->
    return height

  @getWidth: ()->
    return width

  buildSurface: ()->
    state = new StateModifier({
      align: [.5,.5]
      origin: [.5,.5]
    })
    @.node = new RenderNode(state)
    surface = new Surface {
      size: @.size
      content: @.html
    }
    return surface

  templateToHtml: ()->
    return Blaze.toHTMLWithData @.template, @.lesson
