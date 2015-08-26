
class @LessonThumbnail extends Node
  HEIGHT = 400
  WIDTH = 400

  constructor: (@lesson)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5
     .setSizeMode "absolute", "absolute", "absolute"
     .setAbsoluteSize @.WIDTH, @.HEIGHT

    console.log "Setting the domelement"
    @.domElement = new DOMElement @, {
      properties: {
        background: "white"
      }
      content: "<p>LESSON"+ @.lesson.title+ "</p>"
    }
    console.log @
    
    #@.registerEvents()

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
