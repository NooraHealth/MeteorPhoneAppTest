class @Scene
  @get: ()->
    @.scene ?= new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      @.famousScene = FamousEngine.createScene "body"

      @.root = @.famousScene.addChild()

      @.camera = new Camera @.famousScene
      @.camera.setDepth 1000

      @.lessonsView = new LessonsView()
      @.root.addChild @.lessonsView

      @.header = new Header()
      @.root.addChild @.header
      @

    setLessons: (lessons)->
      @.lessons = lessons
      @.lessonsView.setLessons lessons
      @

    setContentSrc: (src)->
      @.src = src
      @

    getContentSrc: ()->
      console.log @.src
      return @.src


