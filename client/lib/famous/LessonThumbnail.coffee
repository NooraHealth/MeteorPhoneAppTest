
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
            <p>#{title}</p>
          </div>
        </div>
        "
    }
    
    #@.registerEvents()

  moveToPosition: (col, row, numCols, numRows)->
    xAlign = col / numCols
    yAlign = row / numRows
    console.log xAlign
    console.log yAlign
    @.setAlign xAlign, yAlign, .5
    

  isCurrentLesson: ()->
    return false

  registerEvents: ()->
    #surface = @.surface

    #surface.on "mouseout", ()=>
      #@.state.halt()
      #if @.isCurrentLesson()
        #@.state.setTransform Transform.scale(1.15, 1.15, 1), {duration: 500, curve: "easeIn"}
      #else
        #@.state.setTransform Transform.scale(1, 1, 1), {duration: 500, curve: "easeIn"}
    
    #surface.on "mouseover", ()=>
      #if @.isCurrentLesson()
        #@.state.setTransform Transform.scale(1.20, 1.20, 1), {duration: 500, curve: "easeIn"}
      #else
        #@.state.setTransform Transform.scale(1.1, 1.1, 1), {duration: 500, curve: "easeIn"}

    #surface.on "click", ()=>
      #Router.go "ModulesSequence", {_id: @.lesson._id}

  @getHeight: ()->
    return @.HEIGHT

  @getWidth: ()->
    return @.WIDTH

