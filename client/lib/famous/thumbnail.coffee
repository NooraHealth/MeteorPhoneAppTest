
class @LessonThumbnail

  height = 400
  width = 400
  constructor: (@lesson)->
    @.size = [width, height]
    @.template = Template.lessonThumbnail
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()

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
