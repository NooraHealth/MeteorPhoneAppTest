
class @ModuleSurface
  constructor: (@template, @module)->
    @.size ?= [700, 600]
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()
    @.registerFamousEvents()
    
  handleClick: (event)=>

  handleInputUpdate: (event)=>

  handleInputEnd: (event)=>

  registerFamousEvents: ()=>
    @.surface.on "click", (event)=>
      @.handleClick(event)
    @.surface.on "deploy", ()=>
      console.log "I have been deployed"
      if @.module.audioSrc()
        ModuleView.playAudio "question", @.module
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

  getModule: ()=>
    return @.module

  buildSurface: ()=>
    id = @.module._id
    console.log id
    return new Surface {
      size: @.size
      content: @.html
      classes: ['white', 'card', 'valign-wrapper', 'module']
    }

  templateToHtml: ()=>
    return Blaze.toHTMLWithData(@.template, @.module)



