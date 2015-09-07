
###
# Slide Surface
###
class @SlideSurface
  @get: ( module, parent )->
    if not @.surface
      @.surface = new PrivateSurface module
      parent.addChild @.surface
    else
      @.surface.setModule module

    return @.surface

  class PrivateSurface extends ModuleSurface
    constructor: ( @_module )->
      super( @._module  )

      @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
       .setProportionalSize .8, .7, 0

      @.domElement = new DOMElement @, {}
      @.domElement.addClass "card"
      @.setContent()

    setContent: ()->
      src = Scene.get().getContentSrc @._module.image
      @.domElement.setContent "
          <div class='valign module-wrapper'>
            <div class='center-align'>
              <img class='module-image' src='#{src}'
            </div>
            <div class='flow-text grey-text text-darken-2 center-align'>
              #{@._module.title} 
            </div>
          </div>
          "
    setModule: ( module )->
      @._module = module
      super
      @.setContent()
      
