
###
# Slide Surface
###
class @SlideSurface extends ModuleSurface
  constructor: ( @module, index )->
    super( @.module , index )

    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, .7, 0

    src = Scene.get().getContentSrc @.module.image
    @.domElement = new DOMElement @, {
      content: "
        <div class='valign module-wrapper'>
          <div class='center-align'>
            <img class='module-image' src='#{src}'
          </div>
          <div class='flow-text grey-text text-darken-2 center-align'>
             #{@.module.title} 
          </div>
        </div>
        "
    }

    @.domElement.addClass "card"
