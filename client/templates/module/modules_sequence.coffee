Template.ModulesSequence.helpers
  modules: ()->
    if _.isEmpty @
      return []
    else
      if @.lesson
        moduleSequence = @.lesson.getModulesSequence()
        Session.set "module sequence", moduleSequence
        Session.set "current module index", 0
        return moduleSequence

  currentModuleID: (nh_id)->
    index = Session.get "current module index"
    sequence = Session.get "module sequence"
    module = sequence[index]
    return module.nh_id == nh_id

Template.ModulesSequence.events
  'click .response': (event, template)->
    response = $(event.target).val()
    moduleSequence = Session.get "module sequence"
    currentModuleIndex = Session.get "current module index"
    module = moduleSequence[currentModuleIndex]

    hideIncorrectResponses(module)
    showSticker(event.target, module)
    playAudio(event.target, module)

playAudio = (response, module)->
  nh_id = module.nh_id
  $("audio[name=audio#{nh_id}][class=question]")[0].pause()
  if $(response).hasClass "correct"
    $("audio[name=audio#{nh_id}][class=correct]")[0].play()
  else
    $("audio[name=audio#{nh_id}][class=incorrect]")[0].play()



showSticker= (response, module) ->
  nh_id = module.nh_id
  console.log response
  
  if $(response).hasClass "correct"
    $("#sticker_correct").removeClass("hidden")
  else
    console.log "showing red sticked"
    $("#sticker_incorrect").removeClass("hidden")


hideIncorrectResponses = (module)->
    nh_id = module.nh_id
    responseBtns =  $("a[name=#{nh_id}]")
    for btn in responseBtns
      if not $(btn).hasClass "correct"
        if $(btn).hasClass "response"
          $(btn).hide()
####
## Tracks the current module in the series and
## moves the current module into visibility when the current module changes
####

Tracker.autorun ()->
  moduleSequence = Session.get "module sequence"
  currentModuleIndex = Session.get "current module index"
  previousModuleIndex = Session.get "previous module index"
  
  if !moduleSequence or !moduleSequence?
    return

  if currentModuleIndex?
    moduleToDisplay = $("#module"+ moduleSequence[currentModuleIndex].nh_id)
    moduleToDisplay.addClass 'visible-module'
    moduleToDisplay.removeClass 'hidden-left'
  
  if previousModuleIndex?
    moduleToHide = $("#module" + moduleSequence[previousModuleIndex].nh_id)
    moduleToHide.removeClass 'visible-module'
    moduleToHide.addClass 'hidden-left'
  
