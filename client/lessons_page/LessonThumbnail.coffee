
class @LessonThumbnail extends Node

  constructor: (@lesson, @index)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign 0, 0, .5
     .setMountPoint 0, 0, .5

    imgSrc = Scene.get().getContentSrc( lesson.image )
    title = lesson.title
    @.domElement = new DOMElement @, {
      properties:
        margin: "0px 30px 0px 30px"

      content:
        "
        <div class='card-image thumbnail-wrapper'>
          <img src='#{imgSrc}' class='thumbnail' />
        </div>
        <div class='card-content'>
          <p class='center-align grey-text text-darken-2'>#{title}</p>
        </div>
        "
    }
    @.domElement.addClass "card"
    
    @.addUIEvent "click"
    #@.registerEvents()

  onReceive: (e, payload) ->
    if e == 'click'
      scene = Scene.get()
      scene.showModules @.lesson

    

