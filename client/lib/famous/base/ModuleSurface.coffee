
class @ModuleSurface extends Node
  constructor: ( @module )->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.size ?= [700, 600]
    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.RELATIVE_SIZE
     .setAbsoluteSize 700, 600

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



