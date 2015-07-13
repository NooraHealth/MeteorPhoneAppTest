
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
    return new Surface {
      size: @.size
      content: @.html
    }

  templateToHtml: ()->
    return Blaze.toHTMLWithData @.template, @.lesson
