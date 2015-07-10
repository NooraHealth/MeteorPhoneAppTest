
class @ModuleSurface
  constructor: (@template, @module)->
    @.size = [600, 400]
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()
    @.registerFamousEvents()

  getModule: ()=>
    return @.module

  handleClick: (event)=>

  handleInputUpdate: (event)=>

  handleInputEnd: (event)=>

  registerFamousEvents: ()=>
    @.surface.on "click", (event)=>
      @.handleClick(event)
    #@.mouseSync.on "start", (event)=>
      #@.handleClick event
    #@.mouseSync.on "end", (event)=>
      #@.handleInputEnd event
    #@.mouseSync.on "update", (event)=>
      #@.handleInputUpdate event

    #@.sync.on "start", (event)=>
      #@.handleClick event
    #@.sync.on "end", (event)=>
      #@.handleInputEnd event
    #@.sync.on "update", (event)=>
      #@.handleInputUpdate event

  getSurface: ()=>
    return @.surface

  buildSurface: ()=>
    return new Surface {
      size: @.size
      content: @.html
    }

  templateToHtml: ()=>
    audio = "<audio id='toplay' src="+@.module.audioSrc()+" autoplay></audio>"
    return audio + Blaze.toHTMLWithData(@.template, @.module)

