
class @LessonThumbnail

  height = 400
  width = 400
  constructor: (@lesson)->
    @.size = [width, height]
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
      content: "<p>cONTENTKL</p>"
    }
