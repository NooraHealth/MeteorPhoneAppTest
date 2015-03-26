Template.binaryChoiceModule.events
  'click .response': (event, template)->
    response = $(event.target).val()
    module = template.data
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

  


  
