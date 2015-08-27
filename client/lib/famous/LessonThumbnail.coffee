
class @LessonThumbnail extends Node

  constructor: (@lesson, @index)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.WIDTH = WIDTH = 250
    @.HEIGHT = HEIGHT = 250

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint 0, 0, 0
     .setSizeMode "relative", "relative", "absolute"

    imgSrc = Scene.get().getContentSrc() + lesson.image
    title = lesson.title
    @.domElement = new DOMElement @, {
      properties:
        margin: "0px 30px 0px 30px"

      content:
        "
        <div class='card'>
          <div class='card-image'>
            <img src='#{imgSrc}' class='thumbnail' />
          </div>
          <div class='card-content'>
            <p class='center-align grey-text text-darken-2'>#{title}</p>
          </div>
        </div>
        "
    }
    
    @.addUIEvent "click"
    #@.registerEvents()

  moveToPosition: (col, row, numCols, numRows)->
    xAlign = col / numCols
    yAlign = row / numRows
    @.setAlign xAlign, yAlign, .5

  onReceive: (e, payload) ->
    if e == 'click'
      scene = Scene.get()
      scene.showModules @.lesson

    

