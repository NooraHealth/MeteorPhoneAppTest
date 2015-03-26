
this.resetModules = (previousModule) ->
  nh_id = previousModule.nh_id

  #Pause all playing audio
  audioArr = $("audio[name=audio#{nh_id}]")
  for audioElem in audioArr
    $(audioElem)[0].pause()

  #Hide the stickers
  $("#sticker_incorrect").addClass "hidden"
  $("#sticker_correct").addClass "hidden"
  

this.playAnswerAudio = (response, module)->
  nh_id = module.nh_id
  $("audio[name=audio#{nh_id}][class=question]")[0].pause()
  if $(response).hasClass "correct"
    $("audio[name=audio#{nh_id}][class=correct]")[0].play()
  else
    $("audio[name=audio#{nh_id}][class=incorrect]")[0].play()

this.goToNextModule = (event, template)-> 
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    resetModules(moduleSequence[currentIndex])
    
    Session.set "previous module index", currentIndex
    Session.set "current module index", ++currentIndex
