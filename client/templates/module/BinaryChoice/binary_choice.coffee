Template.binaryChoiceModule.events
  'click .response': (event, template)->
    console.log "REsponse!"
    response = $(event.target).val()
    module = template.data
    nh_id = module.nh_id
    responseBtns =  $("a[name=#{nh_id}]")
    for btn in responseBtns
      if not $(btn).hasClass "correct"
        if $(btn).hasClass "response"
          $(btn).hide()
    #hideIncorrectResponses()


hideIncorrectResponses = (event)->


  
