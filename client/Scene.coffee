class @Scene
  @get: ()->
    @.scene ?= new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      console.log "constructing a scene"
      @.famousScene = FamousEngine.createScene "body"

      @.root = @.famousScene.addChild()

      @.camera = new Camera @.famousScene
      @.camera.setDepth 1000

      @.lessonsView = new LessonsView()
      @.root.addChild @.lessonsView

      @.header = new Header()
      @.root.addChild @.header

    setLessons: (lessons)->
      @.lessons = lessons
      @.lessonsView.setLessons lessons

