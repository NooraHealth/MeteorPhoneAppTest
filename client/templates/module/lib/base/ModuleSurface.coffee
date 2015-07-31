
class @ModuleSurface
  constructor: (@template, @module)->
    @.size ?= [700, 600]
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()
    @.registerFamousEvents()
    @.deployed = false
    
  handleClick: (event)=>

  handleInputUpdate: (event)=>

  handleInputEnd: (event)=>

  registerFamousEvents: ()=>
    @.surface.on "click", (event)=>
      @.handleClick(event)
    @.surface.on "deploy", ()=>
      if @.deployed
        return

      if ModuleSurface.audioSrc(@.module)
        @.deployed = true
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

  isDeployed: ()=>
    return @.deployed

  equals: (surface)=>
    if not @.module or @.surface.module
      return false
    if @.module._id == surface.module._id
      return true
    else
      return false

  getSurface: ()=>
    return @.surface

  getModule: ()=>
    return @.module

  reset: ()=>
    newSurface = @.buildSurface()
    @.surface = newSurface
    @.registerFamousEvents()
    @.deployed = false

  buildSurface: ()=>
    id = @.module._id
    return new Surface {
      size: @.size
      content: @.html
      classes: ['white', 'card', 'valign-wrapper', 'module']
    }

  templateToHtml: ()=>
    return Blaze.toHTMLWithData(@.template, @.module)

  @imgSrc: (module)->
    url = Meteor.NooraClient.getContentSrc()
    return url + module.image

  @videoSrc: (module)->
    url = Meteor.NooraClient.getContentSrc()
    return url + module.video
      
  @audioSrc: (module)->
    url = Meteor.NooraClient.getContentSrc()
    return url + module.audio

  @correctAnswerAudio: (module)->
    url = Meteor.NooraClient.getContentSrc()
    return url + module.correct_audio

  @incorrectAnswerAudio: (module)->
    url = Meteor.NooraClient.getContentSrc()
    return url + module.incorrect_audio

  @isAQuestion: (module)->
    return module.type == "SCENARIO" or module.type=="BINARY" or module.type=="MULTIPLE_CHOICE" or module.type == "GOAL_CHOICE"

  @buttonDisabled: (btn)->
    return $(btn).hasClass('faded') or $(btn).hasClass('expanded')


